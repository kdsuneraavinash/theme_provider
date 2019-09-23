import 'package:flutter/material.dart';

import '../provider/theme_provider.dart' show ThemeChanged;
import '../data/app_theme.dart';
import 'theme_command.dart';
import 'save_adapter.dart';
import 'shared_preferences_adapter.dart';

/// Handler which provides the activated controller.
typedef void ThemeControllerHandler(
    ThemeCommand controller, Future<String> previouslySavedThemeFuture);

/// Object which controls the behavior of the theme.
/// This is the object provided through the widget tree.
///
/// This implementation is hidden from the external uses.
/// Instead [ThemeCommand] is exposed which is inherited by this class.
///
/// [ThemeCommand] is a reduced API to [ThemeController].
class ThemeController extends ChangeNotifier implements ThemeCommand {
  /// Index of the current theme - the index refers to [_appThemeIds] list.
  int _currentThemeIndex;

  /// Map which maps theme id to the corresponding theme.
  /// No 2 themes cannot have conflicting theme ids.
  final Map<String, AppTheme> _appThemes = Map<String, AppTheme>();

  /// List which stores the sequence in which the themes were provided.
  /// List elements are theme ids which maps back to [_appThemes].
  final List<String> _appThemeIds = List<String>();

  /// Adapter which helps to save current theme and load it back.
  /// Currently uses [SharedPreferenceAdapter] which uses shared_preferences plugin.
  final SaveAdapter _saveAdapter = SharedPreferenceAdapter();

  /// Whether to save the theme on disk every time the theme changes
  final bool _saveThemesOnChange;

  /// Whether to load the theme on initialization.
  /// If this is true, default onInitCallback will be executed instead.
  final bool _loadThemeOnInit;

  final ThemeChanged onThemeChanged;

  /// ThemeProvider id to identify between 2 providers and allow more than 1 provider.
  final String _providerId;

  /// Controller which handles updating and controlling current theme.
  /// [themes] determine the list of themes that will be available.
  /// **[themes] cannot have conflicting [id] parameters**
  /// If conflicting [id]s were found [AssertionError] will be thrown.
  ///
  /// [defaultThemeId] is optional.
  /// If not provided, default theme will be the first provided theme.
  /// Otherwise the given theme will be set as the default theme.
  /// [AssertionError] will be thrown if there is no theme with [defaultThemeId].
  ///
  /// [saveThemesOnChange] is required.
  /// This refers to whether to persist the theme on change.
  /// If it is `true`, theme will be saved to disk whenever the theme changes.
  /// **If you use this, do NOT use nested [ThemeProvider]s as all will be saved in the same key**
  ///
  /// [onInitCallback] is the callback which is called when the ThemeController is first initialed.
  /// You can use this to call `controller.loadThemeById(ID)` or equalent to set theme.
  ///
  /// [loadThemeOnInit] will load a previously saved theme from disk.
  /// If [loadThemeOnInit] is provided, [onInitCallback] will be ignored.
  /// So [onInitCallback] and [loadThemeOnInit] can't both be provided at the same time.
  ThemeController({
    @required String providerId,
    @required List<AppTheme> themes,
    String defaultThemeId,
    @required this.onThemeChanged,
    @required bool saveThemesOnChange,
    @required bool loadThemeOnInit,
    ThemeControllerHandler onInitCallback,
  })  : _saveThemesOnChange = saveThemesOnChange,
        _loadThemeOnInit = loadThemeOnInit,
        _providerId = providerId {
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

    assert(!(onInitCallback != null && _loadThemeOnInit));

    if (_loadThemeOnInit) {
      _getPreviousSavedTheme().then((savedTheme) {
        if (savedTheme != null) setTheme(savedTheme);
      });
    } else if (onInitCallback != null) {
      onInitCallback(this, _getPreviousSavedTheme());
    }
  }

  /// Get the previously saved theme id from disk.
  /// If no previous saved theme, returns nulll.
  Future<String> _getPreviousSavedTheme() async {
    String savedTheme = await _saveAdapter.loadTheme(providerId: _providerId);
    if (savedTheme != null && _appThemes.containsKey(savedTheme)) {
      return savedTheme;
    }
    return null;
  }

  /// Get the current theme
  AppTheme get theme => _appThemes[this.currentThemeId];

  /// Get the current theme id
  String get currentThemeId => _appThemeIds[_currentThemeIndex];

  // Get id of the attached provider
  String get providerId => _providerId;

  /// Sets the current theme to given index.
  /// Additionally this notifies all widgets and saves theme.
  void _setThemeByIndex(int themeIndex) {
    int _oldThemeIndex = _currentThemeIndex;
    _currentThemeIndex = themeIndex;
    notifyListeners();

    if (_saveThemesOnChange) {
      saveThemeToDisk();
    }

    if (onThemeChanged != null) {
      onThemeChanged(
        _appThemes[_appThemeIds[_oldThemeIndex]],
        _appThemes[_appThemeIds[_currentThemeIndex]],
      );
    }
  }

  @override
  void nextTheme() {
    int nextThemeIndex = (_currentThemeIndex + 1) % _appThemes.length;
    _setThemeByIndex(nextThemeIndex);
  }

  @override
  void setTheme(String themeId) {
    assert(_appThemes.containsKey(themeId));

    int themeIndex = _appThemeIds.indexOf(themeId);
    _setThemeByIndex(themeIndex);
  }

  @override
  Future<void> loadThemeFromDisk() async {
    String savedTheme = await _getPreviousSavedTheme();
    if (savedTheme != null) {
      setTheme(savedTheme);
    }
  }

  @override
  Future<void> saveThemeToDisk() async {
    _saveAdapter.saveTheme(_providerId, currentThemeId);
  }

  @override
  List<AppTheme> get allThemes =>
      _appThemeIds.map<AppTheme>((id) => _appThemes[id]).toList();
}
