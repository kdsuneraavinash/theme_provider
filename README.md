# theme_provider

Easy to use, customizable Theme Provider. This provides app color schemes throughout the app and automatically rebuilds the UI dynamically.
You can also persist your color theme as well. Easily store and retrieve user preference without hassle.
This package also provides you with several widgets that can help you to easily add theme switching abilities.
Additionally you can pass option classes to store and provide data which should be associated with the current theme.

[![Codemagic build status](https://api.codemagic.io/apps/5cfb60390824820019d5af6b/5cfb60390824820019d5af6a/status_badge.svg)](https://codemagic.io/apps/5cfb60390824820019d5af6b/5cfb60390824820019d5af6a/latest_build)
[![Pub Package](https://img.shields.io/pub/v/theme_provider.svg)](https://pub.dartlang.org/packages/theme_provider)

## Basic Demonstration

| Basic Usage           | Dialog Box           |
|:-------------:|:-------------:|
| ![Record](next.gif) | ![Record](select.gif) |

## Include in your project

```yaml
dependencies:
  theme_provider: ^0.2.0+3
```

run packages get and import it

```dart
import 'package:theme_provider/theme_provider.dart';
```

## Usage

Wrap your material app like this to use dark theme and light theme out of the box.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (theme) => MaterialApp(
        home: HomePage(),
        theme: theme,
      ),
    );
  }
}
```

Or to provide additional themes, wrap like this:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [
        AppTheme.light(), // This is standard light theme (id is default_light_theme)
        AppTheme.dark(), // This is standard dark theme (id is default_dark_theme)
        AppTheme(
          id: "custom_theme", // Id(or name) of the theme(Has to be unique)
          data: ThemeData(  // Real theme data
            primaryColor: Colors.black,
            accentColor: Colors.red,
          ),
        ),
      ],
      builder: (theme) => MaterialApp(
        home: HomePage(),
        theme: theme,
      ),
    );
  }
}
```

To change the theme:

```dart
 ThemeProvider.controllerOf(context).nextTheme();
 // Or
 ThemeProvider.controllerOf(context).setTheme(THEME_ID);
```

Access current `AppTheme`

```dart
 ThemeProvider.themeOf(context)
```

Access theme data:

```dart
 ThemeProvider.themeOf(context).data
 // or
 Theme.of(context)
```

### Passing Additional Options

This can also be used to pass additional data associated with the theme. Use `options` to pass additional data that should be associated with the theme.
eg: If font color on a specific button changes according to the current theme, create a class to encapsulate the value.

```dart
  class ThemeOptions{
    final Color specificButtonColor;
    ThemeOptions(this.specificButtonColor);
  }
```

Then provide the options with the theme.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [
          AppTheme<ThemeOptions>(
              id: "light_theme",
              data: ThemeData.light(),
              options: ThemeOptions(Colors.blue),
          ),
          AppTheme<ThemeOptions>(
              id: "light_theme",
              data: ThemeData.dark(),
              options: ThemeOptions(Colors.red),
          ),
        ],
        builder: (theme) => MaterialApp(
          home: HomePage(),
          theme: theme,
        ),
    );
  }
}
```

Then the option can be retrieved as,

```dart
ThemeProvider.optionsOf<ThemeOptions>(context).specificButtonColor
```

## Persisting theme

### Saving theme

To persist themes, simply pass `saveThemesOnChange` as `true`.
This will ensure that the theme is saved to the disk.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      builder: (theme) => MaterialApp(
        home: HomePage(),
        theme: theme,
      ),
    );
  }
}
```

Or manually save the current theme by just using,

```dart
ThemeProvider.controllerOf(context).saveThemeToDisk();
```

### Loading saved theme

`defaultThemeId` will always be used to determine the initial theme. (If not provided the first theme you specify will be the default app theme.)
But you can manually load the previous(saved) theme by using:

```dart
 ThemeProvider.controllerOf(context).loadThemeFromDisk();
```

To load a previously saved theme pass `loadThemeOnInit` as true:

```dart
ThemeProvider(
  builder: (theme) => MaterialApp(
        theme: theme,
        home: Scaffold(key: scaffoldKey),
      ),
  saveThemesOnChange: true,
  loadThemeOnInit: true,
)
```

Or to load a theme/do some task at theme controller initialization use `onInitCallback`.
This will get called on the start.

For example, snippet below will load the previously saved theme from the disk. (if previosuly saved.)

```dart
ThemeProvider(
  builder: (theme) => MaterialApp(
        theme: theme,
        home: Scaffold(key: scaffoldKey),
      ),
  defaultThemeId: "theme_1",
  themes: [
    AppTheme.light(id: "theme_1"),
    AppTheme.light(id: "theme_2"),
    AppTheme.light(id: "theme_3"),
  ],
  saveThemesOnChange: true,
  onInitCallback: (controller, previouslySavedThemeFuture) async {
    // Do some other task here if you need to
    String savedTheme = await previouslySavedThemeFuture;
    if (savedTheme != null) {
      controller.setTheme(savedTheme);
    }
  },
)
```

**Warning: Loading a theme will redraw you app.**
So if you loaded the theme immediately at startup, user will see a fliker.

So it is recommended that if you want to load the theme at startup,
show a splash screen or use a theme agnostic startup screen
so the refreshing won't be visible to the user.

Example: Login screen may be designed so that it looks same in all screens.
When the theme loads, it won't be noticeable to the user.
Load the theme in that screen and then the other screens can be themed.

## Additional Widgets

### Theme Cycle Widget

`IconButton` to be added to `AppBar` to cycle to next theme.

```dart
Scaffold(
  appBar: AppBar(
    title: Text("Example App"),
    actions: [CycleThemeIconButton()]
  ),
),
```

### Theme Selecting Dialog

`SimpleDialog` to let the user select the theme.
Many elements in this dialog is customizable.

```dart
showDialog(context: context, builder: (_) => ThemeDialog())
```

## TODO

- [x] Add next theme command
- [x] Add theme cycling widget
- [x] Add theme selection by theme id
- [x] Add theme select and preview widget
- [x] Persist current selected theme
- [x] Add unit tests and example
- [x] Remove provider dependency
- [ ] Add widget - theme selector grid
- [ ] Add dark mode support and automatic mode switch
- [x] Ids for theme_providers to allow multiple theme providers
- [ ] Add example to demostrate persistence

## Bugs/Requests

If you encounter any problems feel free to open an issue.
Pull request are also welcome.
