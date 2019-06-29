import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

/// Wrap a widget to use the theme of the closest app theme of the [ThemeProvider].
/// If you have multiple screens, wrap each entry point with this widget.
class ThemeConsumer extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Wrap a widget to use the theme of the closest app theme of the [ThemeProvider].
  /// If you have multiple screens, wrap each entry point with this widget.
  const ThemeConsumer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeProvider.themeOf(context).data,
      child: child,
    );
  }
}
