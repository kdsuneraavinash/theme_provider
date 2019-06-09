import 'package:flutter/material.dart';

import '../data/app_theme.dart';
import '../controller/theme_controller.dart';
import '../controller/theme_command.dart';
import 'inherited_theme.dart';

/// Signature for a function that returs the current theme and context.
///
/// Used by [ThemeProvider].
typedef Widget ThemedAppBuilder(BuildContext context, ThemeData themeData);

/// Wrap [MaterialApp] in [ThemeProvider] to get theme functionalities.
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

  /// [defaultThemeId] is optional.
  /// If not provided, default theme set by [ThemeController] to be the first provided theme.
  /// Otherwise the given theme will be set as the default theme.
  /// [AssertionError] will be thrown if there is no theme with [defaultThemeId].
  final String defaultThemeId;

  /// List of [AppTheme]s. This list will be passed to the
  /// [ThemeController] when widget is built.
  final List<AppTheme> themes;

  /// [saveThemesOnChange] refers to whether to persist the theme on change.
  /// If it is `true`, theme will be saved to disk whenever the theme changes.
  final bool saveThemesOnChange;

  /// [loadThemesOnStartup] refers to whether to load the theme when the controller is initialized.
  /// If `true`, this will load the default theme provided (or the first theme if default is `null`)
  /// and then asyncronously load the persisted theme.
  final bool loadThemesOnStartup;

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
  /// [defaultThemeId] can also be provided to override the default theme.
  /// (which is the first theme in the [themes] list)
  /// **[AppTheme]s must not have conflicting theme ids.**
  ///
  /// [saveThemesOnChange] refers to whether to persist the theme on change.
  /// On default this is `false`.
  /// If it is `true`, theme will be saved to disk whenever the theme changes.
  /// **If you use this, do NOT use nested [ThemeProvider]s as all will be saved in the same key**
  ///
  /// [loadThemesOnStartup] refers to whether to load the theme when the controller is initialized.
  /// If `true`, this will load the default theme provided (or the first theme if default is `null`)
  /// and then asyncronously load the persisted theme.
  /// If no persisted theme found, the theme will remain as the default one.
  /// By default this is `false`
  ThemeProvider({
    Key key,
    themes,
    this.defaultThemeId,
    @required this.builder,
    this.saveThemesOnChange = false,
    this.loadThemesOnStartup = false,
  })  : this.themes = themes ?? [AppTheme.light(), AppTheme.dark()],
        super(key: key) {
    assert(this.themes.length >= 2, "Theme list must have at least 2 themes.");
  }

  /// Obtains the nearest [ThemeController] up its widget tree and
  /// returns its value as a [ThemeCommand].
  ///
  /// Gets the reference to [ThemeController] but as a reduced version.
  static ThemeCommand controllerOf(BuildContext context) {
    return InheritedThemeController.of(context);
  }

  /// Returs the options passed by the [ThemeProvider].
  /// Call as `ThemeProvider.optionsOf<ColorClass>(context)` to get the
  /// returned object casted to the required type.
  static T optionsOf<T>(BuildContext context) {
    return InheritedThemeController.of(context).theme.options as T;
  }

  /// Returns the current app theme passed by the [ThemeProvider].
  ///
  /// Call as `ThemeProvider.themeOf(context).data` to get [ThemeData].
  /// This is same as `Theme.of(context)` under a theme provider.
  static AppTheme themeOf(BuildContext context) {
    return InheritedThemeController.of(context).theme;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedThemeController(
      controller: ThemeController(
        themes: themes,
        defaultThemeId: defaultThemeId,
        loadThemesOnStartup: loadThemesOnStartup,
        saveThemesOnChange: saveThemesOnChange,
      ),
      child: Builder(
        builder: (context) => builder(
              context,
              ThemeProvider.themeOf(context).data,
            ),
      ),
    );
  }
}
