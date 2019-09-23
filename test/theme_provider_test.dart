import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_provider/src/controller/save_adapter.dart';
import 'package:theme_provider/src/controller/shared_preferences_adapter.dart';
import 'package:theme_provider/theme_provider.dart';

class AppThemeOptionsTester implements AppThemeOptions {
  final Color color;
  AppThemeOptionsTester(this.color);
}

void main() {
  test('ThemeProvider constructor theme list test', () {
    var buildWidgetTree = (List<AppTheme> appThemes) async => ThemeProvider(
          child: MaterialApp(
            home: ThemeConsumer(child: Container()),
          ),
          themes: appThemes,
        );

    expect(() => buildWidgetTree(null), isNotNull);
    expect(() => buildWidgetTree([AppTheme.light()]), throwsAssertionError);
    expect(buildWidgetTree([AppTheme.light(), AppTheme.light()]), isNotNull);

    expect(() => buildWidgetTree([AppTheme.light(), AppTheme.light(id: "")]),
        throwsAssertionError);
    expect(
        () => buildWidgetTree(
            [AppTheme.light(), AppTheme.light(id: "no spaces")]),
        throwsAssertionError);
    expect(
        () =>
            buildWidgetTree([AppTheme.light(), AppTheme.light(id: "No_Upper")]),
        throwsAssertionError);
    expect(
        () => buildWidgetTree([AppTheme.light(), AppTheme.light(id: "ok_id")]),
        isNotNull);
  });

  testWidgets('ThemeProvider ancestor test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        child: MaterialApp(
          home: ThemeConsumer(
            child: Scaffold(key: scaffoldKey),
          ),
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
        child: MaterialApp(
          home: ThemeConsumer(
            child: Scaffold(
              body: Builder(
                builder: (context) => FlatButton(
                  key: buttonKey,
                  child: Text("Press Me"),
                  onPressed: () {
                    ThemeCommand themeCommand =
                        ThemeProvider.controllerOf(context);
                    assert(themeCommand != null);
                    themeCommand.nextTheme();
                  },
                ),
              ),
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
        child: MaterialApp(
          home: ThemeConsumer(
            child: Scaffold(key: scaffoldKey),
          ),
        ),
        themes: [
          AppTheme.light().copyWith(
            id: "light_theme",
            options: AppThemeOptionsTester(Colors.blue),
          ),
          AppTheme.dark().copyWith(
            id: "dark_theme",
            options: AppThemeOptionsTester(Colors.red),
          )
        ],
      ),
    );

    await tester.pump();

    expect(
        ThemeProvider.optionsOf<AppThemeOptionsTester>(
                tester.element(find.byKey(scaffoldKey)))
            .color,
        isNot(Colors.red));
    expect(
        ThemeProvider.optionsOf<AppThemeOptionsTester>(
                tester.element(find.byKey(scaffoldKey)))
            .color,
        equals(Colors.blue));
  });

  testWidgets('Default Theme Id Test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    await tester.pumpWidget(
      ThemeProvider(
        child: MaterialApp(
          home: ThemeConsumer(
            child: Scaffold(key: scaffoldKey),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey))).id,
        startsWith("default_"));
  });

  testWidgets('Duplicate Theme Id Test', (tester) async {
    final errorHandled = expectAsync0(() {});

    FlutterError.onError = (errorDetails) {
      errorHandled();
    };

    await tester.pumpWidget(
      ThemeProvider(
        child: MaterialApp(
          home: ThemeConsumer(
            child: Scaffold(),
          ),
        ),
        themes: [
          AppTheme.light(),
          AppTheme.light(id: "test_theme"),
          AppTheme.light(id: "test_theme"),
        ],
      ),
    );
  });

  testWidgets('Select by Theme Id Test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    var fetchCommand = () =>
        ThemeProvider.controllerOf(tester.element(find.byKey(scaffoldKey)));
    var fetchTheme =
        () => ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey)));

    await tester.pumpWidget(
      ThemeProvider(
        child: MaterialApp(
          home: ThemeConsumer(
            child: Scaffold(key: scaffoldKey),
          ),
        ),
        themes: [
          AppTheme.light(),
          AppTheme.light(id: "test_theme_1"),
          AppTheme.light(id: "test_theme_2"),
          AppTheme.light(id: "test_theme_random"),
        ],
      ),
    );
    expect(fetchTheme().id, equals("default_light_theme"));

    fetchCommand().nextTheme();
    expect(fetchTheme().id, equals("test_theme_1"));

    fetchCommand().setTheme("test_theme_random");
    expect(fetchTheme().id, equals("test_theme_random"));
  });
  testWidgets('Set default theme id test', (tester) async {
    final Key scaffoldKey = UniqueKey();

    var getCurrentThemeId =
        () => ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey))).id;

    var widgetTreeWithDefaultTheme =
        ({String defaultTheme}) async => await tester.pumpWidget(
              ThemeProvider(
                child: MaterialApp(
                  home: ThemeConsumer(
                    child: Scaffold(key: scaffoldKey),
                  ),
                ),
                defaultThemeId: defaultTheme,
                themes: [
                  AppTheme.light(),
                  AppTheme.light(id: "test_theme_1"),
                  AppTheme.light(id: "test_theme_2"),
                  AppTheme.light(id: "test_theme_3"),
                  AppTheme.light(id: "test_theme_4"),
                ],
              ),
            );

    await widgetTreeWithDefaultTheme();
    expect(getCurrentThemeId(), equals("default_light_theme"));

    await widgetTreeWithDefaultTheme(defaultTheme: "test_theme_3");
    expect(getCurrentThemeId(), equals("test_theme_3"));

    final errorHandled = expectAsync0(() {});

    FlutterError.onError = (errorDetails) {
      errorHandled();
    };

    await widgetTreeWithDefaultTheme(defaultTheme: "no_theme");
  });

  test('Persistency test', () async {
    Map<String, dynamic> testStorage = Map();
    defineStorageMethodCallHandler(testStorage);

    String saveKey = 'theme_provider.theme';

    SaveAdapter theme = SharedPreferenceAdapter(saveKey: saveKey);
    expect(testStorage, isNot(contains(saveKey)));
    expect(await theme.loadTheme(providerId: "abc", defaultId: "load_failed"),
        equals("load_failed"));

    await theme.saveTheme("abc", "my_theme");
    expect(testStorage.keys, contains("flutter.$saveKey.abc"));
    expect(await theme.loadTheme(providerId: "abc"), equals("my_theme"));
  });

  testWidgets('Persistency widget test', (tester) async {
    defineStorageMethodCallHandler(Map());

    var buildWidgetTree = (Key scaffoldKey) async {
      await tester.pumpWidget(
        ThemeProvider(
          child: MaterialApp(
            home: ThemeConsumer(
              child: Scaffold(key: scaffoldKey),
            ),
          ),
          defaultThemeId: "test_theme_1",
          saveThemesOnChange: true,
          themes: [
            AppTheme.light(id: "test_theme_1"),
            AppTheme.light(id: "test_theme_2"),
            AppTheme.light(id: "test_theme_3"),
            AppTheme.light(id: "test_theme_4"),
          ],
        ),
      );
    };

    var getCurrentTheme = (Key scaffoldKey) =>
        ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey)));
    var getCurrentController = (Key scaffoldKey) =>
        ThemeProvider.controllerOf(tester.element(find.byKey(scaffoldKey)));

    Key scaffoldKey1 = UniqueKey();
    await buildWidgetTree(scaffoldKey1);
    expect(getCurrentTheme(scaffoldKey1).id, "test_theme_1");
    getCurrentController(scaffoldKey1).setTheme('test_theme_3');
    expect(getCurrentTheme(scaffoldKey1).id, "test_theme_3");

    await tester.pump();

    Key scaffoldKey2 = UniqueKey();
    await buildWidgetTree(scaffoldKey2);
    await tester.pump();
    expect(getCurrentTheme(scaffoldKey2).id, "test_theme_1");

    await getCurrentController(scaffoldKey2).loadThemeFromDisk();
    expect(getCurrentTheme(scaffoldKey2).id, "test_theme_3");
  });

  testWidgets('Persistency widget set theme on init test', (tester) async {
    defineStorageMethodCallHandler(Map());

    var buildWidgetTree = (Key scaffoldKey) async {
      await tester.pumpWidget(
        ThemeProvider(
          child: MaterialApp(
            home: ThemeConsumer(
              child: Scaffold(key: scaffoldKey),
            ),
          ),
          defaultThemeId: "second_test_theme_1",
          saveThemesOnChange: true,
          themes: [
            AppTheme.light(id: "second_test_theme_1"),
            AppTheme.light(id: "second_test_theme_2"),
            AppTheme.light(id: "second_test_theme_3"),
          ],
          onInitCallback: (controller, previouslySavedThemeFuture) async {
            String savedTheme = await previouslySavedThemeFuture;
            if (savedTheme != null) {
              controller.setTheme(savedTheme);
            }
          },
        ),
      );
    };

    var getCurrentTheme = (Key scaffoldKey) =>
        ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey)));
    var getCurrentController = (Key scaffoldKey) =>
        ThemeProvider.controllerOf(tester.element(find.byKey(scaffoldKey)));

    Key scaffoldKey1 = UniqueKey();
    await buildWidgetTree(scaffoldKey1);
    expect(getCurrentTheme(scaffoldKey1).id, "second_test_theme_1");
    getCurrentController(scaffoldKey1).setTheme('second_test_theme_3');
    expect(getCurrentTheme(scaffoldKey1).id, "second_test_theme_3");

    await tester.pump();

    Key scaffoldKey2 = UniqueKey();
    await buildWidgetTree(scaffoldKey2);
    await tester.pump();
    expect(getCurrentTheme(scaffoldKey2).id, "second_test_theme_3");
  });

  testWidgets('On theme changed callback test', (tester) async {
    var _oldThemeId;
    var _currentThemeId = "second_test_theme_1";

    var buildWidgetTree = (Key scaffoldKey) async {
      await tester.pumpWidget(
        ThemeProvider(
          child: MaterialApp(
            home: ThemeConsumer(
              child: Scaffold(key: scaffoldKey),
            ),
          ),
          defaultThemeId: _currentThemeId,
          themes: [
            AppTheme.light(id: "second_test_theme_1"),
            AppTheme.light(id: "second_test_theme_2"),
            AppTheme.light(id: "second_test_theme_3"),
          ],
          onThemeChanged: (oldTheme, newTheme) {
            _oldThemeId = oldTheme.id;
            _currentThemeId = newTheme.id;
          },
        ),
      );
    };

    var getCurrentTheme = (Key scaffoldKey) =>
        ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey)));
    var getCurrentController = (Key scaffoldKey) =>
        ThemeProvider.controllerOf(tester.element(find.byKey(scaffoldKey)));

    Key scaffoldKey1 = UniqueKey();
    await buildWidgetTree(scaffoldKey1);

    expect(_oldThemeId, isNull);
    expect(getCurrentTheme(scaffoldKey1).id, equals(_currentThemeId));

    getCurrentController(scaffoldKey1).setTheme('second_test_theme_3');

    expect(_oldThemeId, equals("second_test_theme_1"));
    expect(_currentThemeId, equals("second_test_theme_3"));
    expect(getCurrentTheme(scaffoldKey1).id, equals(_currentThemeId));

    await tester.pump();
  });

  testWidgets('Persistency auto load parameter', (tester) async {
    defineStorageMethodCallHandler(Map());

    var buildWidgetTree = (Key scaffoldKey) async {
      await tester.pumpWidget(
        ThemeProvider(
          child: MaterialApp(
            home: ThemeConsumer(
              child: Scaffold(key: scaffoldKey),
            ),
          ),
          defaultThemeId: "third_test_theme_1",
          saveThemesOnChange: true,
          themes: [
            AppTheme.light(id: "third_test_theme_1"),
            AppTheme.light(id: "third_test_theme_2"),
            AppTheme.light(id: "third_test_theme_3"),
          ],
          loadThemeOnInit: true,
        ),
      );
    };

    var getCurrentTheme = (Key scaffoldKey) =>
        ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey)));
    var getCurrentController = (Key scaffoldKey) =>
        ThemeProvider.controllerOf(tester.element(find.byKey(scaffoldKey)));

    Key scaffoldKey1 = UniqueKey();
    await buildWidgetTree(scaffoldKey1);
    expect(getCurrentTheme(scaffoldKey1).id, "third_test_theme_1");
    getCurrentController(scaffoldKey1).setTheme('third_test_theme_3');
    expect(getCurrentTheme(scaffoldKey1).id, "third_test_theme_3");

    await tester.pump();

    Key scaffoldKey2 = UniqueKey();
    await buildWidgetTree(scaffoldKey2);
    await tester.pump();
    expect(getCurrentTheme(scaffoldKey2).id, "third_test_theme_3");
  });

  testWidgets('Multiple Theme Provider', (tester) async {
    defineStorageMethodCallHandler(Map());

    var buildWidgetTree = (Key scaffoldKey, [String providerId]) async {
      await tester.pumpWidget(
        ThemeProvider(
          child: MaterialApp(
            home: ThemeConsumer(
              child: Scaffold(key: scaffoldKey),
            ),
          ),
          providerId: providerId,
          defaultThemeId: "fourth_test_theme_1",
          saveThemesOnChange: true,
          loadThemeOnInit: true,
          themes: [
            AppTheme.light(id: "fourth_test_theme_1"),
            AppTheme.light(id: "fourth_test_theme_2"),
            AppTheme.light(id: "fourth_test_theme_3"),
          ],
        ),
      );
    };

    var getCurrentTheme = (Key scaffoldKey) =>
        ThemeProvider.themeOf(tester.element(find.byKey(scaffoldKey)));
    var getCurrentController = (Key scaffoldKey) =>
        ThemeProvider.controllerOf(tester.element(find.byKey(scaffoldKey)));

    Key scaffoldKey1 = UniqueKey();
    String firstId = "A";
    await buildWidgetTree(scaffoldKey1, firstId);
    expect(getCurrentTheme(scaffoldKey1).id, "fourth_test_theme_1");
    getCurrentController(scaffoldKey1).setTheme('fourth_test_theme_3');
    expect(getCurrentTheme(scaffoldKey1).id, "fourth_test_theme_3");

    Key scaffoldKey2 = UniqueKey();
    String secondId = "B";
    await buildWidgetTree(scaffoldKey2, secondId);
    expect(getCurrentTheme(scaffoldKey2).id, "fourth_test_theme_1");
    getCurrentController(scaffoldKey2).setTheme('fourth_test_theme_2');
    expect(getCurrentTheme(scaffoldKey2).id, "fourth_test_theme_2");

    await tester.pump();

    Key scaffoldKey3 = UniqueKey();
    await buildWidgetTree(scaffoldKey3, firstId);
    await tester.pump();
    expect(getCurrentTheme(scaffoldKey3).id, "fourth_test_theme_3");

    Key scaffoldKey4 = UniqueKey();
    await buildWidgetTree(scaffoldKey4, secondId);
    await tester.pump();
    expect(getCurrentTheme(scaffoldKey4).id, "fourth_test_theme_2");
  });
}

void defineStorageMethodCallHandler(Map<String, dynamic> testStorage) {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return testStorage;
    } else if (methodCall.method == 'setString') {
      var args = methodCall.arguments;
      String key = args['key'];
      String value = args['value'];
      testStorage[key] = value;
      return true;
    } else {
      throw AssertionError("Invalid method call: $methodCall");
    }
  });
}
