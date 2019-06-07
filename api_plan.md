```dart
import 'package:flutter/material.dart';

class DataOptions{
	final Color textColorOnPrimaryColor;
	final Color textColorOnAccentColor;

	DataOptions({this.textColorOnPrimaryColor, this.textColorOnAccentColor});
}


class MyApp extends StatelessWidget{
	@override
	Widget build(BuildContext context){
		return ThemeProvider(
			loadFromDeviceIfPossible: true,
			saveThemeChangesToDevice: true,
			defaultThemeId: "dark_theme",
			themeSwitchErrorHandler: ThemeSwitchErrorHandler.SILENTLY_DEFAULT,
			themes: [
				DefaultTheme.pinkAppTheme(
					options: DataOptions(
							textColorOnPrimaryColor: Colors.black,
							textColorOnAccentColor: Colors.black,
						),
					),
				AppTheme(
					id: "dark_theme",
					description: "Dark theme - white combined with black",
					data: ThemeData(
							primaryColor: Colors.black,
							accentColor: Colors.white,
							brightness: Brightness.dark,
						),
					options: DataOptions(
							textColorOnPrimaryColor: Colors.white,
							textColorOnAccentColor: Colors.black,
						),
				),
				AppTheme(
					id: "light_theme",
					description: "Light theme - only white",
					data: ThemeData(
							primaryColor: Colors.white,
							accentColor: Colors.white,
							brightness: Brightness.dark,
						),
					options: DataOptions(
							textColorOnPrimaryColor: Colors.black,
							textColorOnAccentColor: Colors.black,
						),
				),
			],
			app: MaterialApp(
				home: HomePage(),
			),
		);
	}
}


class HomePage extends StatelessWidget{
	@override
	Widget build(BuildContext context){
		return Scaffold(
				appBar: AppBar(title: Text("Example"), actions: CycleThemeIconButton()),
				body: Builder(
					builder: (context) => Center(
						child: FlatButton(
							child: Text("Press ME",
									style: TextStyle(color: AppThemeOptions.of(context).textColorOnAccentColor)
								),
							onPressed(){
								ThemeController.of(context).nextTheme();
								ThemeController.of(context).prevTheme();

								if (Theme.of(context).brightness == Brightness.light){
									ThemeController.of(context).setTheme('dark_theme');
								}

								showDialog(context: context, ThemeSelectorDialog());
							}
						),
					),
				),
			);
	}
}
```