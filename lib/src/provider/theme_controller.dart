import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme/app_theme.dart';
import 'theme_command.dart';

class ThemeController extends ChangeNotifier implements ThemeCommand {
  int _currentThemeId;
  final List<AppTheme> _appThemes;

  /// Controller which handles updating and controlling current theme.
  /// If [themes] is not given, default set of themes will be used.
  ThemeController({List<AppTheme> themes}) : this._appThemes = themes {
    _currentThemeId = 0;
  }

  /// Get the current theme
  AppTheme get theme => _appThemes[_currentThemeId];

  /// Gets the reference to [ThemeController] directly.
  /// This also provides references to current theme and other objects.
  /// So this class is not exported. 
  /// Only the classes inside this package can use this.
  static ThemeController of(BuildContext context) {
    return Provider.of<ThemeController>(context);
  }

  @override
  void nextTheme() {
    _currentThemeId = (_currentThemeId + 1) % _appThemes.length;
    notifyListeners();
  }
}
