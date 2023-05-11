import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        final view = View.of(context);
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              // ignore: use_build_context_synchronously
              view.platformDispatcher.platformBrightness;
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
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static const String customAppThemeId = 'custom_theme';

  const HomePage({super.key});

  AppTheme customAppTheme() {
    return AppTheme(
      id: customAppThemeId,
      description: "Custom Color Scheme",
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = ThemeProvider.controllerOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Example App")),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SecondPage()));
              },
            ),
            const Divider(),
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
            const Divider(),
            controller.hasTheme(customAppThemeId)
                ? const Text('Custom theme added')
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
        onPressed: onPressed,
        child: Text(text),
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
        title: const Text("Second Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ThemeProvider.controllerOf(context).nextTheme,
          child: const Text("Next Theme"),
        ),
      ),
    );
  }
}
