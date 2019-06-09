import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: <AppTheme>[
        AppTheme.light(),
        AppTheme.dark(),
        customAppTheme(),
      ],
      builder: (context, theme) => MaterialApp(
            theme: theme,
            home: HomePage(),
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
      splashColor: Colors.green,
      appBarTheme: AppBarTheme(elevation: 10),
      dialogBackgroundColor: Colors.yellow
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
                  showDialog(context: context, builder: (_) => ThemeDialog());
                }),
          ],
        ),
      ),
    );
  }
}
