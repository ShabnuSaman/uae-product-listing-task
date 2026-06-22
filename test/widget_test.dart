import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Products'), findsOneWidget);
  });
}
