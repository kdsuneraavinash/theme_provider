import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  test('ThemeProvider constructor theme list test', () {
    final AppTheme appTheme = AppTheme(data: ThemeData.light());

    var buildWidgetTree = (List<AppTheme> appThemes) async => ThemeProvider(
          builder: (_, theme) => Container(),
          themes: appThemes,
        );

    expect(() => buildWidgetTree([]), throwsAssertionError);
    expect(() => buildWidgetTree([appTheme]), throwsAssertionError);
    expect(buildWidgetTree([appTheme, appTheme]), isNotNull);
  });

  testWidgets('ThemeProvider ancestor test', (tester) async {
    final AppTheme appTheme = AppTheme(data: ThemeData.light());
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(key: scaffoldKey),
            ),
        themes: [appTheme, appTheme],
      ),
    );

    await tester.pump();
    expect(
        find.ancestor(
          of: find.byKey(scaffoldKey),
          matching: find.byType(ThemeProvider),
        ),
        findsWidgets);
  });

  testWidgets('Basic Theme Change test', (tester) async {
    final Key buttonKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(
                body: FlatButton(
                  key: buttonKey,
                  child: Text("Press Me"),
                  onPressed: () {
                    ThemeCommand themeCommand = ThemeCommand.of(context);
                    assert(themeCommand != null);
                    themeCommand.nextTheme();
                  },
                ),
              ),
            ),
        themes: [
          AppTheme(data: ThemeData.light()),
          AppTheme(data: ThemeData.dark())
        ],
      ),
    );

    await tester.pump();

    expect(Theme.of(tester.element(find.byKey(buttonKey))).brightness,
        equals(Brightness.light));

    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();

    expect(Theme.of(tester.element(find.byKey(buttonKey))).brightness,
        equals(Brightness.dark));
  });

  testWidgets('Basic Theme Change test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(key: scaffoldKey),
            ),
        themes: <AppTheme<String>>[
          AppTheme(data: ThemeData.light(), options: "Hello"),
          AppTheme(data: ThemeData.dark(), options: "Bye")
        ],
      ),
    );

    await tester.pump();

    expect(AppThemeOptions.of<String>(tester.element(find.byKey(scaffoldKey))),
        isNot("Bye"));
    expect(AppThemeOptions.of<String>(tester.element(find.byKey(scaffoldKey))),
        equals("Hello"));
  });

  testWidgets('Default Theme Id Test', (tester) async {
    final AppTheme appTheme = AppTheme(data: ThemeData.light());
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(key: scaffoldKey),
            ),
        themes: [appTheme, appTheme],
      ),
    );

    await tester.pump();

    expect(
        ThemeCommand.of(tester.element(find.byKey(scaffoldKey))).currentThemeId,
        startsWith("themeId_"));
  });
}
