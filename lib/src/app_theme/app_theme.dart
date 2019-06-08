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
  static int _initializedThemeIds = 0;
  final ThemeData data;
  final T options;
  final String id;

  AppTheme({
    String id,
    @required ThemeData data,
    T options,
  })  : this.data = data,
        this.options = options,
        this.id = id ?? "themeId_${_initializedThemeIds++}";

  factory AppTheme.light() {
    return AppTheme(data: ThemeData.light());
  }

  factory AppTheme.dark() {
    return AppTheme(data: ThemeData.dark());
  }

  AppTheme copyWith({
    String id,
    ThemeData data,
    T options,
  }) {
    return AppTheme(
      id: id,
      data: data ?? this.data,
      options: options ?? this.options,
    );
  }
}
