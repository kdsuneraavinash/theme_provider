import '../../theme_provider.dart';

/// Reduced API to be exposed of the [ThemeController].
/// Can use to get the current active theme id,
/// or to change it using [setTheme(String id)] or [nextTheme()] methods.
abstract class ThemeCommand {
  /// Cycle to next theme in the theme list.
  /// The sequence is determined by the sequence
  /// specified in the [ThemeProvider] in the [themes] parameter.
  void nextTheme();

  /// Selects the theme by the given theme id.
  /// Throws an [AssertionError] if the theme id is not found.
  void setTheme(String themeId);

  /// Loads previously saved theme from disk.
  /// If this fails(no previous saved theme) it will be ignored.
  /// (No exceptions will be thrown)
  Future<void> loadThemeFromDisk();

  /// Loads current theme to disk.
  Future<void> saveThemeToDisk();

  /// Returns the list of all themes.
  List<AppTheme> get allThemes;
}
