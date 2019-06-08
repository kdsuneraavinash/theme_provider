import 'package:flutter/material.dart';

import '../provider/theme_provider.dart';

/// Simple [IconButton] which cycles themes when pressed.
/// Use as a descendent of [ThemeProvider].
class CycleThemeIconButton extends StatelessWidget {
  final IconData icon;

  const CycleThemeIconButton({Key key, this.icon = Icons.palette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: ThemeProvider.controllerOf(context).nextTheme,
    );
  }
}
