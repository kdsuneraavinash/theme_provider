import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/src/provider/theme_controller.dart';

abstract class ThemeCommand {
  /// Cycle to next theme in the theme list
  void nextTheme();

  static ThemeCommand of(BuildContext context) {
    return Provider.of<ThemeController>(context);
  }
}
