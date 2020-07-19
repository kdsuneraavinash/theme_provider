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
            RaisedButton(
              child: Text("Next Theme"),
              onPressed: controller.nextTheme,
            ),
            RaisedButton(
              child: Text("Theme Dialog"),
              onPressed: () {
                showDialog(context: context, builder: (_) => ThemeDialog());
              },
            ),
            RaisedButton(
              child: Text("Second Screen"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SecondPage()));
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Add Custom Theme"),
              onPressed: controller.hasTheme(customAppThemeId)
                  ? null
                  : () => controller.addTheme(customAppTheme()),
            ),
            RaisedButton(
              child: Text("Remove Custom Theme"),
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
