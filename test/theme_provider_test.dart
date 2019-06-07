import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  test('ThemeProvider constructor theme list test', () {
    AppTheme appTheme = AppTheme(data: ThemeData.light());

    expect(() => _buildMaterialApp([]), throwsAssertionError);
    expect(() => _buildMaterialApp([appTheme]), throwsAssertionError);
    expect(_buildMaterialApp([appTheme, appTheme]), isInstanceOf<Widget>());
  });
}

Widget _buildMaterialApp(List<AppTheme> themes) {
  return ThemeProvider(
    app: MaterialApp(),
    themes: themes,
  );
}
