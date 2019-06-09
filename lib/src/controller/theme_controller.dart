import 'package:flutter/material.dart';

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
  /// [defaultThemeId] is optional.
  /// If not provided, default theme will be the first provided theme.
  /// Otherwise the given theme will be set as the default theme.
  /// [AssertionError] will be thrown if there is no theme with [defaultThemeId].
  ThemeController({@required List<AppTheme> themes, String defaultThemeId}) {
    for (AppTheme theme in themes) {
      assert(!this._appThemes.containsKey(theme.id),
          "Conflicting theme ids found: ${theme.id} is already added to the widget tree,");
      this._appThemes[theme.id] = theme;
      _appThemeIds.add(theme.id);
    }

    if (defaultThemeId == null) {
      _currentThemeIndex = 0;
    } else {
      _currentThemeIndex = _appThemeIds.indexOf(defaultThemeId);
      assert(_currentThemeIndex != -1,
          "No app theme with the default theme id: $defaultThemeId");
    }
  }

  /// Get the current theme
  AppTheme get theme => _appThemes[this.currentThemeId];

  /// Get the current theme id
  String get currentThemeId => _appThemeIds[_currentThemeIndex];

  @override
  void nextTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % _appThemes.length;
    notifyListeners();
  }

  @override
  void setTheme(String themeId) {
    assert(_appThemes.containsKey(themeId));

    _currentThemeIndex = _appThemeIds.indexOf(themeId);
    notifyListeners();
  }

  @override
  List<AppTheme> get allThemes =>
      _appThemeIds.map<AppTheme>((id) => _appThemes[id]).toList();
}
