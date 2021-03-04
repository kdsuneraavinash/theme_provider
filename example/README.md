# Theme Provider Demo

## ▶ Web Demo

Web demo is available in [https://kdsuneraavinash.github.io/theme_provider](https://kdsuneraavinash.github.io/theme_provider)
See below for examples with and without null-safety.

## 👨‍💻 Code (With Null Safety)

```dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance?.window.platformBrightness ??
                  Brightness.light;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('light');
          }
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme.light(id: 'light'),
        AppTheme.dark(id: 'dark'),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            title: 'Material App',
            home: HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static final String customAppThemeId = 'custom_theme';

  AppTheme customAppTheme() {
    return AppTheme(
      id: customAppThemeId,
      description: "Custom Color Scheme",
      data: ThemeData(
        accentColor: Colors.yellow,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.yellow[200],
        buttonColor: Colors.amber,
        dialogBackgroundColor: Colors.yellow,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.red),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = ThemeProvider.controllerOf(context);

    return Scaffold(
      appBar: AppBar(title: Text("Example App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(
              text: "Next Theme",
              onPressed: controller.nextTheme,
            ),
            _buildButton(
              text: "Theme Dialog",
              onPressed: () {
                showDialog(context: context, builder: (_) => ThemeDialog());
              },
            ),
            _buildButton(
              text: "Second Screen",
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SecondPage()));
              },
            ),
            Divider(),
            _buildButton(
              text: "Add Custom Theme",
              onPressed: controller.hasTheme(customAppThemeId)
                  ? null
                  : () => controller.addTheme(customAppTheme()),
            ),
            _buildButton(
              text: "Remove Custom Theme",
              onPressed: controller.hasTheme(customAppThemeId)
                  ? controller.theme.id != customAppThemeId
                  ? () => controller.removeTheme(customAppThemeId)
                  : null
                  : null,
            ),
            Divider(),
            controller.hasTheme(customAppThemeId)
                ? Text('Custom theme added')
                : Container(),
            Text('Current theme: ${controller.theme.id}'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String text, VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Next Theme"),
          onPressed: ThemeProvider.controllerOf(context).nextTheme,
        ),
      ),
    );
  }
}
```

## 👨‍💻 Code (Without Null Safety)

```dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance.window.platformBrightness;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('light');
          }
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme.light(id: 'light'),
        AppTheme.dark(id: 'dark'),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            title: 'Material App',
            home: HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static final String customAppThemeId = 'custom_theme';

  AppTheme customAppTheme() {
    return AppTheme(
      id: customAppThemeId,
      description: "Custom Color Scheme",
      data: ThemeData(
          accentColor: Colors.yellow,
          primaryColor: Colors.red,
          scaffoldBackgroundColor: Colors.yellow[200],
          buttonColor: Colors.amber,
          dialogBackgroundColor: Colors.yellow,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: Colors.red)
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = ThemeProvider.controllerOf(context);

    return Scaffold(
      appBar: AppBar(title: Text("Example App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(
              text: "Next Theme",
              onPressed: controller.nextTheme,
            ),
            _buildButton(
              text: "Theme Dialog",
              onPressed: () {
                showDialog(context: context, builder: (_) => ThemeDialog());
              },
            ),
            _buildButton(
              text: "Second Screen",
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SecondPage()));
              },
            ),
            Divider(),
            _buildButton(
              text: "Add Custom Theme",
              onPressed: controller.hasTheme(customAppThemeId)
                  ? null
                  : () => controller.addTheme(customAppTheme()),
            ),
            _buildButton(
              text: "Remove Custom Theme",
              onPressed: controller.hasTheme(customAppThemeId)
                  ? controller.theme.id != customAppThemeId
                  ? () => controller.removeTheme(customAppThemeId)
                  : null
                  : null,
            ),
            Divider(),
            controller.hasTheme(customAppThemeId)
                ? Text('Custom theme added')
                : Container(),
            Text('Current theme: ${controller.theme.id}'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({String text, VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Next Theme"),
          onPressed: ThemeProvider.controllerOf(context).nextTheme,
        ),
      ),
    );
  }
}
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
