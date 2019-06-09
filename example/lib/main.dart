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
        customTheme(),
      ],
      builder: (context, theme) => MaterialApp(
            theme: theme,
            home: HomePage(),
          ),
    );
  }
}

AppTheme customTheme() => AppTheme(
      data: ThemeData(
        accentColor: Colors.yellow,
        primaryColor: Colors.red,
      ),
      id: "custom_theme",
      description: "Light Theme w/ Red",
    );

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example App"),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child:
                    Text("Current Theme: ${ThemeProvider.themeOf(context).id}"),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlineButton(
                  child: Text("Next Theme"),
                  onPressed: ThemeProvider.controllerOf(context).nextTheme,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlineButton(
                  child: Text("Theme Dialog"),
                  onPressed: () => showDialog(
                      context: context, builder: (_) => ThemeDialog()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
