import 'package:flutter/material.dart';

import '../provider/theme_controller.dart';

/// Simple Usage:
/// ```dart
/// AppThemeOptions.of<ColorClass>(context).primaryColor
/// ```
class AppThemeOptions {
  static T of<T>(BuildContext context) {
    return ThemeController.of(context).theme.options as T;
  }
}
