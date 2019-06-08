import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: <AppTheme>[
        AppTheme(data: ThemeData.light()),
        AppTheme(data: ThemeData.dark()),
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
        child: OutlineButton(
          child: Text("Next Theme"),
          onPressed: ThemeCommand.of(context).nextTheme,
        ),
      ),
    );
  }
}
