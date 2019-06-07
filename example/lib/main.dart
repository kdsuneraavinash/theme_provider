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
      app: MaterialApp(
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
        actions: <Widget>[CycleThemeIconButton()],
      ),
      body: Center(
        child: FlatButton(
          child: Text("Press Me"),
          onPressed: ThemeCommand.of(context).nextTheme,
        ),
      ),
    );
  }
}
