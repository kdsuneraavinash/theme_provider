import 'package:flutter/material.dart';

import '../../theme_provider.dart';

///  Main App theme object.
///
/// Usage:
/// ```dart
///  AppTheme<ColorClass>(
///     data: ThemeData(),
///     options: ColorClass(),
///   ),
/// ```
@immutable
class AppTheme {
  /// [ThemeData] associated with the [AppTheme]
  final ThemeData data;

  /// Passed options object. Use this object to pass
  /// additional data that should be associated with the theme.
  ///
  /// eg: If font color on a specific button changes create a class
  /// to encapsulate the value.
  /// ```dart
  /// class MyThemeOptions implements AppThemeOptions{
  ///   final Color specificButtonColor;
  ///   ThemeOptions(this.specificButtonColor);
  /// }
  /// ```
  ///
  /// Then provide the options with the theme.
  /// ```dart
  /// themes: [
  ///   AppTheme(
  ///     data: ThemeData.light(),
  ///     options: MyThemeOptions(Colors.blue),
  ///   ),
  ///   AppTheme(
  ///     data: ThemeData.dark(),
  ///     options: MyThemeOptions(Colors.red),
  ///   ),
  /// ]
  /// ```
  ///
  /// Then the option can be retrieved as
  /// `ThemeProvider.optionsOf<MyThemeOptions>(context).specificButtonColor`.
  final AppThemeOptions? options;

  /// Unique ID which defines the theme.
  /// Don't use conflicting strings.
  ///
  /// This has to be a lowercase string separated by underscores. (can contain numbers)
  ///   * theme_1
  ///   * my_theme
  ///   * dark_extended_theme
  ///
  /// Don't use very lengthy strings.
  /// Instead use [description] as the field to add description.
  final String id;

  /// Short description which describes the theme. Must be less than 30 characters.
  final String description;

  /// Constructs a [AppTheme].
  /// [data] is required.
  ///
  /// [id] is required and it has to be unique.
  /// Use _ separated lowercase strings.
  /// Id cannot have spaces.
  ///
  /// [options] can ba any object. Use it to pass
  ///
  /// [description] is optional. If not given it takes default to as 'Light Theme' or 'Dark Theme'.
  AppTheme({
    required this.id,
    required this.data,
    required this.description,
    this.options,
  }) {
    assert(description.length < 30, "Theme description too long ($id)");
    assert(id.isNotEmpty, "Id cannot be empty");
    assert(id.toLowerCase() == id, "Id has to be a lowercase string");
    assert(!id.contains(" "), "Id cannot contain spaces. (Use _ for spaces)");
  }

  /// Default light theme
  factory AppTheme.light({String? id}) {
    return AppTheme(
      data: ThemeData.light(),
      id: id ?? "default_light_theme",
      description: "Android Default Light Theme",
    );
  }

  /// Default dark theme
  factory AppTheme.dark({String? id}) {
    return AppTheme(
      data: ThemeData.dark(),
      id: id ?? "default_dark_theme",
      description: "Android Default Dark Theme",
    );
  }

  /// Additional purple theme constructor
  factory AppTheme.purple({String? id}) {
    final theme = ThemeData.light();
    return AppTheme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.pink,
          primary: Colors.purple,
        ),
      ),
      id: id ?? "default_purple_theme",
      description: "Custom Default Purple Theme",
    );
  }

  /// Creates a copy of this [AppTheme] but with the given fields replaced with the new values.
  /// Id will be replaced by the given [id].
  AppTheme copyWith({
    required String id,
    String? description,
    ThemeData? data,
    AppThemeOptions? options,
  }) {
    return AppTheme(
      id: id,
      description: description ?? this.description,
      data: data ?? this.data,
      options: options ?? this.options,
    );
  }
}
