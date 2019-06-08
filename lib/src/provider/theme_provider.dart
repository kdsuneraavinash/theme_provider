import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme/app_theme.dart';

import 'theme_controller.dart';

/// Signature for a function that returs the current theme and context.
///
/// Used by [ThemeProvider].
typedef Widget ThemedAppBuilder(BuildContext context, ThemeData themeData);

class ThemeProvider extends StatelessWidget {
  /// Called to obtain the child app.
  ///
  /// Here the [context] provided is the context directly under [Provider<T>].
  /// So it can be used to access the [ThemeCommand] as `ThemeCommand.of(context)`.
  ///
  /// [themeData] provided refers to the current theme.
  /// Use it to provide theme data to the [MaterialApp] as,
  /// ```dart
  /// ThemeProvider(
  ///   builder: (_, theme) => MaterialApp(
  ///         theme: theme,
  ///         home: HomePage(),
  ///       ),
  /// )
  /// ```
  ///
  /// This will ensure that app gets rebuilt when the theme changes.
  final ThemedAppBuilder builder;

  /// List of [AppTheme]s. This list will be passed to the
  /// [ThemeController] when widget is built.
  final List<AppTheme> themes;

  /// Creates a [ThemeProvider].
  /// Wrap [MaterialApp] in [ThemeProvider] to get theme functionalities.
  /// Usage example:
  /// ```dart
  /// ThemeProvider(
  ///   builder: (_, theme) => MaterialApp(
  ///         theme: theme,
  ///         home: HomePage(),
  ///       ),
  /// )
  /// ```
  ///
  /// If [themes] are not suppies [AppTheme.light()] and [AppTheme.dark()] is assumed.
  ///
  /// If [themes] are supplied, theere have to be at least 2 [AppTheme] objects inside
  /// the list. Otherwise an [AssertionError] is thrown.
  ///
  /// **[AppTheme]s must not have conflicting theme ids.**
  ThemeProvider({
    Key key,
    themes,
    @required this.builder,
  })  : this.themes = themes ?? [AppTheme.light(), AppTheme.dark()],
        super(key: key) {
    assert(this.themes.length >= 2, "Theme list must have at least 2 themes.");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeController>.value(
      value: ThemeController(themes: themes),
      child: Builder(
          builder: (context) => builder(
                context,
                ThemeController.of(context).theme.data,
              )),
    );
  }
}
