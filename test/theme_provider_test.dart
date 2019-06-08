import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  test('ThemeProvider constructor theme list test', () {
    var buildWidgetTree = (List<AppTheme> appThemes) async => ThemeProvider(
          builder: (_, theme) => Container(),
          themes: appThemes,
        );

    expect(() => buildWidgetTree(null), isNotNull);
    expect(() => buildWidgetTree([AppTheme.light()]), throwsAssertionError);
    expect(buildWidgetTree([AppTheme.light(), AppTheme.light()]), isNotNull);
  });

  testWidgets('ThemeProvider ancestor test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(key: scaffoldKey),
            ),
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
        themes: [
          AppTheme<String>.light().copyWith(options: "Hello"),
          AppTheme<String>.dark().copyWith(options: "Bye")
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
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(key: scaffoldKey),
            ),
      ),
    );

    await tester.pump();

    expect(
        ThemeCommand.of(tester.element(find.byKey(scaffoldKey))).currentThemeId,
        startsWith("themeId_"));
  });

  testWidgets('Duplicate Theme Id Test', (tester) async {
    final errorHandled = expectAsync0(() {});

    FlutterError.onError = (errorDetails) {
      errorHandled();
    };

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(),
            ),
        themes: [
          AppTheme.light(),
          AppTheme.light().copyWith(id: "test_theme"),
          AppTheme.light().copyWith(id: "test_theme"),
        ],
      ),
    );
  });

  testWidgets('Select by Theme Id Test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    var fetchThemeCommand =
        () => ThemeCommand.of(tester.element(find.byKey(scaffoldKey)));

    await tester.pumpWidget(
      ThemeProvider(
        builder: (context, theme) => MaterialApp(
              theme: theme,
              home: Scaffold(key: scaffoldKey),
            ),
        themes: [
          AppTheme.light(),
          AppTheme.light().copyWith(id: "test_theme_1"),
          AppTheme.light().copyWith(id: "test_theme_2"),
          AppTheme.light().copyWith(id: "test_theme_random"),
        ],
      ),
    );
    expect(fetchThemeCommand().currentThemeId, startsWith("themeId_"));

    fetchThemeCommand().nextTheme();
    expect(fetchThemeCommand().currentThemeId, equals("test_theme_1"));

    fetchThemeCommand().setTheme("test_theme_random");
    expect(fetchThemeCommand().currentThemeId, equals("test_theme_random"));
  });
}
