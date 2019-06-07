# theme_provider

Easy to use, customizable and pluggable Theme Provider. 

**This is still a work in progress.**

## Include in your project

```yaml
dependencies:
  theme_provider: ^0.0.1
```
run packages get and import it
```dart
import 'package:theme_provider/theme_provider.dart';
```
if you want the dialog:
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

```

To change the theme:
```dart
 ThemeCommand.of(context).nextTheme();
```

Access theme data using default method:

```dart
 Theme.of(context).data
```

## TODO

- [x] Add next theme command
- [x] Add theme cycling widget
- [ ] Add theme selection by theme id
- [ ] Add theme select and preview widget
- [ ] Persist current selected theme
- [ ] Add unit tests and example

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).