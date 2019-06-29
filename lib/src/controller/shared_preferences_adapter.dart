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
  Future<String> loadTheme({String providerId, String defaultId}) async {
    assert(providerId != null, "Provider ID must be provided");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("$saveKey.$providerId") ?? defaultId;
  }

  @override
  Future<void> saveTheme(String providerId, String themeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("$saveKey.$providerId", themeId);
  }
}
