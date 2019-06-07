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
  final ThemeData data;
  final T options;

  AppTheme({
    @required this.data,
    this.options,
  });
}
