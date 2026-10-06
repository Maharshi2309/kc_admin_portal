// Each organization's leave policy (2026-10-06): its paid and unpaid type
// names, days earned per month, an optional carry-forward cap, and paid
// leave on or off. Keshav Clothing's policy is the approved Casual rule.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_auth.dart';

void main() {
  late ProviderContainer container;
  MockTenant tenant(String id) => container.read(mockTenantProvider(id));

  setUp(() => container = createTestContainer());

  // Sanjay Makwana (Keshav): joined 2024, no leave in the samples.
  const sanjay = '10';

  test("Keshav's policy is the approved Casual rule", () async {
    final keshav = tenant(MockSession.keshavId);
    final policy = await keshav.organization.leavePolicy();
    expect(policy.paidLeaveName, 'Casual');
    expect(policy.daysPerMonth, 1);
    expect(policy.carryForwardCap, isNull);
    expect((await keshav.leaves.types()).map((t) => t.name), [
      'Casual',
      'Unpaid',
    ]);
    expect(keshav.leaves.balance(sanjay).accrued, 9); // January–September
  });

  test("another organization's names, rate and cap", () async {
    container.read(mockSessionProvider).start('u1', MockSession.sunriseId);
    final sunrise = tenant(MockSession.sunriseId);
    final types = await sunrise.leaves.types();
    expect(types.map((t) => t.name), ['Paid leave', 'Unpaid leave']);
    expect(types.first.hasBalance, isTrue);
    // 1.5 a month from January would be 13.5 by September; the cap is 12.
    final ravi = sunrise.leaves.balance('s1');
    expect(ravi.accrued, 12);
    expect(ravi.remaining, 12);
  });

  test('changing the policy recalculates balances at once', () async {
    final keshav = tenant(MockSession.keshavId);
    final policy = await keshav.organization.leavePolicy();
    await keshav.organization.updateLeavePolicy(
      policy.copyWith(daysPerMonth: 2, paidLeaveName: 'Earned leave'),
    );
    expect(keshav.leaves.balance(sanjay).accrued, 18);
    // The renamed type shows on leave already taken.
    final leaves = await keshav.leaves.list(const LeaveQuery(pageSize: 50));
    expect(
      leaves.items
          .where((l) => l.isPaid)
          .every((l) => l.leaveType.name == 'Earned leave'),
      isTrue,
    );
  });

  test('paid leave off: only unpaid leave can be added', () async {
    final keshav = tenant(MockSession.keshavId);
    final policy = await keshav.organization.leavePolicy();
    await keshav.organization.updateLeavePolicy(
      policy.copyWith(paidLeaveEnabled: false),
    );
    expect((await keshav.leaves.types()).map((t) => t.id), ['unpaid']);
    await expectLater(
      keshav.leaves.create(
        LeaveFormData(
          employeeId: sanjay,
          leaveTypeId: 'casual',
          startDate: DateTime(2026, 10, 5),
          endDate: DateTime(2026, 10, 5),
          isHalfDay: false,
          reason: LeaveReason.travel,
          status: LeaveStatus.approved,
        ),
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.fieldErrors.keys,
          'field',
          contains('leaveTypeId'),
        ),
      ),
    );
    // Past paid leave stays as it was.
    final leaves = await keshav.leaves.list(const LeaveQuery(pageSize: 50));
    expect(leaves.items.any((l) => l.isPaid), isTrue);
  });

  test('the policy is checked like the server', () async {
    final organization = tenant(MockSession.keshavId).organization;
    final policy = await organization.leavePolicy();
    for (final bad in [
      policy.copyWith(unpaidLeaveName: 'casual'),
      policy.copyWith(daysPerMonth: 0.3),
      policy.copyWith(daysPerMonth: 6),
      policy.copyWith(carryForwardCap: 0.5),
      policy.copyWith(accrualStartMonth: DateTime(2026, 1, 15)),
    ]) {
      await expectLater(
        organization.updateLeavePolicy(bad),
        throwsA(isA<ValidationException>()),
        reason: '$bad',
      );
    }
  });

  test("a new organization's choice: the preset or unpaid only", () async {
    final directory = container.read(mockDirectoryProvider);
    final withPaid = directory.createOrganization(
      name: 'Bright Bakery',
      timezone: 'Asia/Dubai',
    );
    final unpaidOnly = directory.createOrganization(
      name: 'Quiet Studio',
      timezone: 'Asia/Dubai',
      paidLeave: false,
    );
    // Created through the API, the creator becomes the owner.
    for (final organization in [withPaid, unpaidOnly]) {
      tenant(
        organization.id,
      ).access.addOwner(userId: 'u1', name: 'Admin', email: 'admin@keshav.in');
    }
    // Each organization answers only its own sessions.
    final session = container.read(mockSessionProvider)
      ..start('u1', withPaid.id);
    final preset = await tenant(withPaid.id).organization.leavePolicy();
    expect(preset.paidLeaveEnabled, isTrue);
    expect(preset.daysPerMonth, 1);
    expect(preset.carryForwardCap, isNull);
    expect(preset.accrualStartMonth, DateTime(2026, 9)); // the month created

    session.start('u1', unpaidOnly.id);
    final none = await tenant(unpaidOnly.id).organization.leavePolicy();
    expect(none.paidLeaveEnabled, isFalse);
  });
}
