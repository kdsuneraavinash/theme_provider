# theme_provider

[![Codemagic build status](https://api.codemagic.io/apps/5cfb60390824820019d5af6b/5cfb60390824820019d5af6a/status_badge.svg)](https://codemagic.io/apps/5cfb60390824820019d5af6b/5cfb60390824820019d5af6a/latest_build)
[![Pub Package](https://img.shields.io/pub/v/theme_provider.svg)](https://pub.dartlang.org/packages/theme_provider)

Easy to use, customizable Theme Provider.
**This is still a work in progress.**

| Basic Usage           | Basic Usage           |
|:-------------:|:-------------:|
| ![Record](next.gif) | ![Record](select.gif) |

## Include in your project

```yaml
dependencies:
  theme_provider: ^0.0.1
```

run packages get and import it

```dart
import 'package:theme_provider/theme_provider.dart';
```

## Usage

Wrap your material app like this:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, theme) => MaterialApp(
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
eg: If font color on a specific button changes create a class to encapsulate the value.

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
      themes: themes: [
          AppTheme<ThemeOptions>(
              data: ThemeData.light(),
              options: ThemeOptions(Colors.blue),
          ),
          AppTheme<ThemeOptions>(
              data: ThemeData.dark(),
              options: ThemeOptions(Colors.red),
          ),
        ],
        builder: (context, theme) => MaterialApp(
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

To persist themes simply pass `loadThemesOnStartup` and `saveThemesOnChange` as `true`.
This will ensure that the theme is saved and loaded from disk.
If a previous saved theme was found, it will replace the `defaultThemeId`.
Otherwise `defaultThemeId` will be used to determine the initial theme.

**Warning: Setting persistance will cause your app to be refreshed at startup(which may cause a flicker)**
So it is recommended that if you use this feature, show a splash screen or use a theme agnostic startup screen
so the refreshing won't be visible to the user.

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

```dart
showDialog(context: context, builder: (_) => ThemeDialog())
```

## TODO

- [x] Add next theme command
- [x] Add theme cycling widget
- [x] Add theme selection by theme id
- [x] Add theme select and preview widget
- [ ] Persist current selected theme
- [x] Add unit tests and example
- [x] Remove provider dependency

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
