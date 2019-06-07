import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CycleThemeIconButton extends StatelessWidget {
  final IconData icon;

  const CycleThemeIconButton({Key key, this.icon = Icons.palette})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: ThemeCommand.of(context).nextTheme,
    );
  }
}
