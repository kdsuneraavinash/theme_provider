import 'package:flutter/material.dart';

/// Usage:
/// ```dart
///  AppTheme<ColorClass>(
///     data: ThemeData(),
///     options: SimpleDataClass(),
///   ),
/// ```
@immutable
class AppTheme<T> {
  static int _themesWithoutIds = 0;
  final ThemeData data;
  final T options;
  final String id;

  AppTheme({
    id,
    @required data,
    options,
  })  : this.data = data,
        this.options = options,
        this.id = id ?? "themeId_${++_themesWithoutIds}";
}
