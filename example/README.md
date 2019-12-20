# Theme Provider Demo

## ▶ Web Demo

Web demo is available in [https://kdsuneraavinash.github.io/theme_provider](https://kdsuneraavinash.github.io/theme_provider)

## 👨‍💻 Code

```dart
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: <AppTheme>[
        AppTheme.light(),
        AppTheme.dark(),
        customAppTheme(),
      ],
      child: MaterialApp(
        home: ThemeConsumer(
          child: HomePage(),
        ),
      ),
    );
  }
}

AppTheme customAppTheme() {
  return AppTheme(
    id: "custom_theme",
    description: "Custom Color Scheme",
    data: ThemeData(
      accentColor: Colors.yellow,
      primaryColor: Colors.red,
      scaffoldBackgroundColor: Colors.yellow[200],
      buttonColor: Colors.amber,
      dialogBackgroundColor: Colors.yellow,
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Next Theme"),
              onPressed: ThemeProvider.controllerOf(context).nextTheme,
            ),
            RaisedButton(
              child: Text("Theme Dialog"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => ThemeConsumer(child: ThemeDialog()));
              },
            ),
            RaisedButton(
              child: Text("Second Screen"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThemeConsumer(child: SecondPage()),
                  ),
                );
              },
            ),
          ],
        ),
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
        child: RaisedButton(
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
