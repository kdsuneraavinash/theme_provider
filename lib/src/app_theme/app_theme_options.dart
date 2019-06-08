import 'package:flutter/material.dart';

import '../provider/theme_controller.dart';

/// Returs the options passed by the [ThemeProvider].
/// Call as `AppThemeOptions.of<ColorClass>(context)` to get the
/// returned object casted to the required type.
class AppThemeOptions {
  static T of<T>(BuildContext context) {
    return ThemeController.of(context).theme.options as T;
  }
}
