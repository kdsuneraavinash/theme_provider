import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_theme.dart';
import 'theme_command.dart';

/// Object which controls the behavour of the theme.
/// This is the object provided throgh the widget tree.
///
/// This inmplementation is hidden from the external uses.
/// Instead [ThemeCommand] is exposed which is inherited by this class.
///
/// [ThemeCommand] is a reduced API to [ThemeController].
class ThemeController extends ChangeNotifier implements ThemeCommand {
  /// Index of the current theme - the index refers to [_appThemeIds] list.
  int _currentThemeIndex;

  /// Map which maps theme id to the corresponding theme.
  /// No 2 themes cannot have conflicting theme ids.
  final Map<String, AppTheme> _appThemes = Map<String, AppTheme>();

  /// List which stores the sequence in which the thems were provided.
  /// List elements are theme ids which maps back to [_appThemes].
  final List<String> _appThemeIds = List<String>();

  /// Controller which handles updating and controlling current theme.
  /// [themes] determine the list of themes that will be available.
  /// **[themes] cannot have confilcting [id] parameters**
  /// If conflicting [id]s were found [AssertionError] will be thrown.
  ///
  /// Default theme will be the first provided theme.
  /// FEATURE: Set default theme to be specified.
  ThemeController({@required List<AppTheme> themes}) {
    _currentThemeIndex = 0;

    for (AppTheme theme in themes) {
      assert(!this._appThemes.containsKey(theme.id),
          "Conflicting theme ids found.");
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
