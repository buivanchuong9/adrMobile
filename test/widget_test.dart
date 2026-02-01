import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_adr_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdasApp());

    // Verify that the SignInScreen is displayed
    // We can look for the "ADAS Fleet Manager" text or similar
    expect(find.text('ADAS Fleet Manager'), findsOneWidget);
  });
}
