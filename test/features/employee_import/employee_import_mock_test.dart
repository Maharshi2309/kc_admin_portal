// Importing employees from Excel (2026-10-06), with the dev mock playing
// the backend: any column order and names, checks before anything is saved,
// duplicates by EC number, and a report of what wasn't imported.
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/mock_excel.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/xlsx.dart';

void main() {
  late ProviderContainer container;
  late MockTenant keshav;

  setUp(() {
    container = createTestContainer();
    keshav = container.read(mockTenantProvider(MockSession.keshavId));
  });

  // A company's own file: different names and order than the template.
  final ownFile = xlsx([
    ['Employee Code', 'Employee Name', 'Designation', 'Dept', 'Phone', 'DOJ'],
    [
      'KC2001',
      'Asha Iyer',
      'Tailor',
      'Tailor',
      '+91 98765 43210',
      DateTime(2026, 9, 1),
    ],
    [
      'KC2002',
      'Ben Mathew',
      'Accountant',
      'Accountant',
      '9876500001',
      '15/08/2026',
    ],
    ['', 'No Code', 'Tailor', 'Tailor', '9876500002', '01/09/2026'],
    ['KC2001', 'Twice Listed', 'Tailor', 'Tailor', '9876500003', '01/09/2026'],
    ['KC2004', 'Bad Date', 'Tailor', 'Tailor', '9876500004', '31/02/2026'],
    ['KC2005', 'New Dept', 'Tailor', 'Pressing', '9876500005', '01/09/2026'],
    ['KC1001', 'Aarav Shah', 'Tailor', 'Tailor', '9825011234', '12/01/2021'],
  ]);

  Future<EmployeeImportModel> checked(
    EmployeeImportModel upload, {
    DuplicateStrategy duplicates = DuplicateStrategy.skip,
    bool createMissing = false,
    bool assignEcNumbers = false,
  }) => keshav.employeeImport.check(
    upload.id,
    ImportOptionsModel(
      mapping: upload.suggestedMapping,
      duplicateStrategy: duplicates,
      createMissing: createMissing,
      assignEcNumbers: assignEcNumbers,
    ),
  );

  test('reads any column order and guesses the mapping', () async {
    final upload = await keshav.employeeImport.upload(ownFile, 'staff.xlsx');
    expect(upload.headers, hasLength(6));
    expect(upload.rowCount, 7);
    expect(upload.suggestedMapping, {
      'Employee Code': 'ecNumber',
      'Employee Name': 'name',
      'Designation': 'position',
      'Dept': 'department',
      'Phone': 'mobile',
      'DOJ': 'joiningDate',
    });
    expect(upload.sampleRows.first.first, 'KC2001');
  });

  test('checks every row before anything is saved', () async {
    final before = (await keshav.employeeSource.list(
      const EmployeeQuery(status: null),
    )).total;
    final result = await checked(
      await keshav.employeeImport.upload(ownFile, 'staff.xlsx'),
    );
    expect(result.status, ImportStatus.validated);
    expect(result.counts!.valid, 2); // Asha, Ben
    expect(result.counts!.errors, 4);
    expect(result.counts!.skipped, 1); // KC1001 exists
    expect(
      (await keshav.employeeSource.list(
        const EmployeeQuery(status: null),
      )).total,
      before,
    );

    final problems = await keshav.employeeImport.rows(result.id);
    String messagesOf(int row) =>
        problems.items.firstWhere((r) => r.rowNumber == row).messages.join();
    expect(messagesOf(4), contains('EC number is missing'));
    expect(messagesOf(5), contains('also on row 2'));
    expect(messagesOf(6), contains("isn't a date"));
    expect(messagesOf(7), contains('"Pressing" isn\'t in Settings'));
  });

  test('options: create missing, assign EC numbers, update existing', () async {
    final result = await checked(
      await keshav.employeeImport.upload(ownFile, 'staff.xlsx'),
      duplicates: DuplicateStrategy.update,
      createMissing: true,
      assignEcNumbers: true,
    );
    // Asha, Ben, No Code, New Dept and the update of KC1001.
    expect(result.importable, 5);
    expect(result.counts!.errors, 2); // the duplicate row, the bad date

    final rows = await keshav.employeeImport.rows(
      result.id,
      filter: ImportRowFilter.all,
    );
    final update = rows.items.firstWhere((r) => r.ecNumber == 'KC1001');
    expect(update.status, ImportRowStatus.warning);
    expect(update.changes.map((c) => c.field), contains('Position'));
  });

  test('confirm imports the passing rows; the report has the rest', () async {
    final upload = await keshav.employeeImport.upload(ownFile, 'staff.xlsx');
    await checked(upload, createMissing: true, assignEcNumbers: true);
    final done = await keshav.employeeImport.confirm(upload.id);
    expect(done.status, ImportStatus.completed);
    expect(done.result!.imported, 4);
    expect(done.result!.skipped, 1);
    expect(done.result!.failed, 2);

    final asha = (await keshav.employeeSource.list(
      const EmployeeQuery(search: 'Asha Iyer'),
    )).items.single;
    expect(asha.ecNumber, 'KC2001');
    expect(asha.mobile, '9876543210');
    expect(asha.joiningDate, DateTime(2026, 9));
    // Without hours in the file, the default schedule.
    expect(
      (await keshav.employeeSource.getById(
        asha.id,
      )).schedule?.startTime.minutes,
      9 * 60 + 30,
    );
    final noCode = (await keshav.employeeSource.list(
      const EmployeeQuery(search: 'No Code'),
    )).items.single;
    expect(noCode.ecNumber, startsWith('KC'));
    final pressing = (await keshav.organization.catalog(
      CatalogKind.departments,
    )).where((d) => d.name == 'Pressing');
    expect(pressing, hasLength(1));

    final report = MockExcel.read(
      await keshav.employeeImport.report(upload.id),
    );
    expect(report.headers.first, 'Row');
    expect(report.headers.last, 'Reason');
    expect(report.rows, hasLength(3)); // 2 failed + 1 skipped
  });

  test('update changes only what the file has', () async {
    final upload = await keshav.employeeImport.upload(
      xlsx([
        ['EC number', 'Position'],
        ['KC1001', 'Tailor'],
      ]),
      'update.xlsx',
    );
    final result = await keshav.employeeImport.check(
      upload.id,
      ImportOptionsModel(
        mapping: upload.suggestedMapping,
        duplicateStrategy: DuplicateStrategy.update,
      ),
    );
    // Only EC number and position: the rest is required for new rows only.
    expect(result.counts!.warnings, 1);
    await keshav.employeeImport.confirm(upload.id);
    final aarav = await keshav.employeeSource.getById('1');
    expect(aarav.position.name, 'Tailor');
    expect(aarav.name, 'Aarav Shah');
    expect(aarav.department.name, 'Graphic Designer');
  });

  test('a required field without a column is refused', () async {
    final upload = await keshav.employeeImport.upload(ownFile, 'staff.xlsx');
    await expectLater(
      keshav.employeeImport.check(
        upload.id,
        ImportOptionsModel(
          mapping: {...upload.suggestedMapping, 'DOJ': null},
          duplicateStrategy: DuplicateStrategy.skip,
        ),
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('Joining date'),
        ),
      ),
    );
  });

  test('files are checked by their content', () async {
    for (final (bytes, reason) in [
      (Uint8List.fromList([1, 2, 3, 4]), 'not an Excel file'),
      (Uint8List.fromList([0xD0, 0xCF, 0x11, 0xE0, 0]), '.xls'),
      (xlsx([]), 'empty'),
      (
        xlsx([
          ['Name'],
        ]),
        'no rows',
      ),
    ]) {
      await expectLater(
        keshav.employeeImport.upload(bytes, 'file.xlsx'),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.message,
            'message',
            contains(reason),
          ),
        ),
        reason: reason,
      );
    }
  });

  test('the template reads back with every field mapped', () async {
    final template = await keshav.employeeImport.template();
    final upload = await keshav.employeeImport.upload(
      template,
      'template.xlsx',
    );
    expect(upload.headers, MockExcel.templateHeaders.values);
    expect(upload.suggestedMapping.values.toSet(), {
      for (final field in ImportField.values) field.name,
    });
    final result = await checked(upload);
    expect(result.counts!.valid, 1); // the example row
  });
}
