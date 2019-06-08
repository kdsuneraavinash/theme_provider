import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme/app_theme.dart';
import 'theme_command.dart';

class ThemeController extends ChangeNotifier implements ThemeCommand {
  int _currentThemeIndex;
  final Map<String, AppTheme> _appThemes = Map<String, AppTheme>();
  final List<String> _appThemeIds = List<String>();

  /// Controller which handles updating and controlling current theme.
  /// If [themes] is not given, default set of themes will be used.
  ThemeController({List<AppTheme> themes}) {
    _currentThemeIndex = 0;

    for (AppTheme theme in themes) {
      assert(!this._appThemes.containsKey(theme.id));
      this._appThemes[theme.id] = theme;
      _appThemeIds.add(theme.id);
    }
  }

  /// Get the current theme
  AppTheme get theme => _appThemes[this.currentThemeId];

  /// Gets the reference to [ThemeController] directly.
  /// This also provides references to current theme and other objects.
  /// So this class is not exported.
  /// Only the classes inside this package can use this.
  static ThemeController of(BuildContext context) {
    return Provider.of<ThemeController>(context);
  }

  @override
  void nextTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % _appThemes.length;
    notifyListeners();
  }

  @override
  String get currentThemeId => _appThemeIds[_currentThemeIndex];

  @override
  void setTheme(String themeId) {
    assert(_appThemes.containsKey(themeId));
    _currentThemeIndex = _appThemeIds.indexOf(themeId);
    notifyListeners();
  }
}
