import 'package:flutter_test/flutter_test.dart';
import 'package:appgate/main.dart';

void main() {
  testWidgets('AppGate smoke test — app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const AppGate());
    expect(find.text('AppGate'), findsOneWidget);
  });
}
