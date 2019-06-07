import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mockup_app.dart';

void main() {
  testWidgets('Basic App Theme and Mockup App Smoke Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MockupApp());

    Finder pressMeButton = find.text('Press Me');
    expect(pressMeButton, findsOneWidget);

    expect(
        find.ancestor(
          of: pressMeButton,
          matching: find.byType(Provider),
        ),
        findsOneWidget);

    await tester.tap(pressMeButton);
    await tester.pump();
  });
}
