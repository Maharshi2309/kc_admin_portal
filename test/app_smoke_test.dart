import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_auth.dart';

void main() {
  testWidgets('app boots into the dashboard when signed in', (tester) async {
    await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );

    expect(find.text('Dashboard'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
