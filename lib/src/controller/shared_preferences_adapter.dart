import 'package:shared_preferences/shared_preferences.dart';

import 'save_adapter.dart';

/// Concrete implementation of [SaveAdapter].
/// This uses [SharedPreferences] to save and load.
class SharedPreferenceAdapter extends SaveAdapter {
  /// String to be used when saving and loading theme.
  final String saveKey;

  /// Creates a [SaveAdapter] using [SharedPreferences].
  ///
  /// [saveKey] will be a String to be used when saving and loading theme.
  /// If not provided this defaults to `theme_provider.theme`.
  SharedPreferenceAdapter({this.saveKey = 'theme_provider.theme'});

  @override
  Future<String> loadTheme({String defaultId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(saveKey) ?? defaultId;
  }

  @override
  Future<void> saveTheme(String themeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(saveKey, themeId);
  }
}
