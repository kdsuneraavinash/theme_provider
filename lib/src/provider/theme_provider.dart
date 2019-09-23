import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../data/app_theme.dart';
import '../controller/theme_controller.dart';
import '../controller/theme_command.dart';
import 'inherited_theme.dart';

// Callback to called after theme changed
typedef void ThemeChanged(AppTheme oldTheme, AppTheme newTheme);

/// Wrap [MaterialApp] in [ThemeProvider] to get theme functionalities.
/// You may wrap seperate parts of the app with multiple [ThemeProvider]s
/// to use multiple theme sections across the app.
class ThemeProvider extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Optional field which will set the default theme out of themes provided in [themes].
  /// If not provided, default theme will be the first provided theme.
  final String defaultThemeId;

  /// List of themes to be available for child listners.
  /// If [themes] are not supplies [AppTheme.light()] and [AppTheme.dark()] is assumed.
  /// If [themes] are supplied, there have to be at least 2 [AppTheme] objects inside the list.
  final List<AppTheme> themes;

  /// Whether to persist the theme on change.
  /// If `true`, theme will be saved to disk whenever the theme changes.
  /// By default this is `false`.
  final bool saveThemesOnChange;

  /// Whether to load the theme on initialization.
  /// If `true`, default [onInitCallback] will be executed instead.
  final bool loadThemeOnInit;

  /// The callback which is to be called when the [ThemeController] is first initialed.
  final ThemeControllerHandler onInitCallback;

  /// The callback which is to be called when the [AppTheme] is changed.
  final ThemeChanged onThemeChanged;

  /// Theme provider id to distinguish between ThemeProviders.
  /// Provide distinct values if you intend to use multiple theme providers.
  final String providerId;

  /// Creates a [ThemeProvider].
  /// Wrap [MaterialApp] in [ThemeProvider] to get theme functionalities.
  /// You may wrap seperate parts of the app with multiple [ThemeProvider]s
  /// to use multiple theme sections across the app.
  ThemeProvider({
    Key key,
    this.providerId = "default",
    List<AppTheme> themes,
    this.defaultThemeId,
    this.onInitCallback,
    this.onThemeChanged,
    @required this.child,
    this.saveThemesOnChange = false,
    this.loadThemeOnInit = false,
  })  : this.themes = themes ?? [AppTheme.light(), AppTheme.dark()],
        super(key: key) {
    assert(this.themes.length >= 2, "Theme list must have at least 2 themes.");
  }

  /// Gives reference to a [ThemeCommand] of the nearest [ThemeProvider] up the widget tree
  /// and will provide commands to change the theme.
  static ThemeCommand controllerOf(BuildContext context) {
    return InheritedThemeController.of(context);
  }

  /// Returns the options passed by the nearest [ThemeProvider] up the widget tree.
  /// Call as `ThemeProvider.optionsOf<ColorClass>(context)` to get the
  /// returned object casted to the required type.
  static T optionsOf<T extends AppThemeOptions>(BuildContext context) {
    return InheritedThemeController.of(context).theme.options as T;
  }

  /// Returns the current app theme passed by the nearest [ThemeProvider] up the widget tree.
  /// Use as `ThemeProvider.themeOf(context).data` to get [ThemeData].
  static AppTheme themeOf(BuildContext context) {
    return InheritedThemeController.of(context).theme;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedThemeController(
      controller: ThemeController(
        providerId: providerId,
        themes: themes,
        defaultThemeId: defaultThemeId,
        onInitCallback: onInitCallback,
        onThemeChanged: onThemeChanged,
        loadThemeOnInit: loadThemeOnInit,
        saveThemesOnChange: saveThemesOnChange,
      ),
      child: child,
    );
  }
}
