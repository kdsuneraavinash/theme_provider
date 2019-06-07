import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  test('ThemeProvider constructor theme list test', () {
    AppTheme appTheme = AppTheme(data: ThemeData.light());

    expect(() => _buildMaterialApp([]), throwsAssertionError);
    expect(() => _buildMaterialApp([appTheme]), throwsAssertionError);
    expect(_buildMaterialApp([appTheme, appTheme]), isInstanceOf<Widget>());
  });

  testWidgets('Test that ThemeProvider is found as ancestor of MaterialApp',
      (tester) async {
    AppTheme appTheme = AppTheme(data: ThemeData.light());
    await tester.pumpWidget(_buildMaterialApp([appTheme, appTheme]));
    await tester.pump();
    expect(
        find.ancestor(
            of: find.byType(MaterialApp), matching: find.byType(ThemeProvider)),
        findsWidgets);

    await tester.tap(find.byType(FlatButton));
    await tester.pump();
  });
}

Widget _buildMaterialApp(List<AppTheme> themes) {
  return ThemeProvider(
    app: MaterialApp(
      home: Container(
        child: Builder(
          builder: (context) => FlatButton(
                child: Text("Hello"),
                onPressed: () {
                  ThemeCommand.of(context).toString();
                },
              ),
        ),
      ),
    ),
    themes: themes,
  );
}
