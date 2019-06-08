import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: <AppTheme>[
        AppTheme.light().copyWith(id: "light_theme"),
        AppTheme.dark().copyWith(id: "dark_theme")
      ],
      builder: (context, theme) => MaterialApp(
            theme: theme,
            home: HomePage(),
          ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Current Theme: ${ThemeCommand.of(context).currentThemeId}"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                child: Text("Next Theme"),
                onPressed: ThemeCommand.of(context).nextTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
