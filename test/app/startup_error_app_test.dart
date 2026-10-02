import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/app/startup_error_app.dart';

void main() {
  testWidgets('shows the startup problem instead of a blank screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const StartupErrorApp(message: 'API_BASE_URL is missing or invalid.'),
    );

    expect(find.text('The app could not start'), findsOneWidget);
    expect(find.text('API_BASE_URL is missing or invalid.'), findsOneWidget);
  });
}
