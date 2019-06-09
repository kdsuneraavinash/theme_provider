import 'package:flutter/material.dart';

import '../provider/theme_provider.dart';
import '../data/app_theme.dart';

/// Gives a [AppTheme] and builds a [Color].
///
/// Used by [ThemeDialog].
typedef Color ColorBuilderByAppTheme(AppTheme theme);

/// Ready-made [SimpleDialog] that gives the option to change theme.
class ThemeDialog extends StatelessWidget {
  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  final Widget title;

  /// Whether to show the subtitle with theme description.
  final bool hasDescription;

  /// Radius of the inner circle of theme item.
  /// Must be a value less than or equal to 20.
  /// (If equal to 20, outer circle will disappear)
  final double innerCircleRadius;

  /// Builder for inner circle color.
  /// If not provided, uses `primaryColor`.
  final ColorBuilderByAppTheme innerCircleColorBuilder;

  /// Builder for outer circle color.
  /// If not provided, uses `accentColor`.
  final ColorBuilderByAppTheme outerCircleColorBuilder;

  /// Duration for item selection checkmark opacity animation.
  /// Value is in milliseconds.
  /// Defaults to 300.
  final int animatedOpacityDuration;

  /// Selected item icon to show as an overlay.
  /// Defaults to a white [Icons.check]
  final Widget selectedThemeIcon;

  /// Color for show as an overlay over selected icon.
  /// Use a transparent color to show behind overlay.
  /// Defaults to transparent grey.
  final Color selectedOverlayColor;

  /// Constructor for [ThemeDialog]. Builds a [SimpleDialog] to switch themes.
  /// Use as:
  /// ```dart
  /// showDialog(context: context, builder: (_) => ThemeDialog())
  /// ```
  ThemeDialog({
    this.title = const Text("Select Theme"),
    this.hasDescription = true,
    this.innerCircleRadius = 15,
    this.innerCircleColorBuilder,
    this.outerCircleColorBuilder,
    this.animatedOpacityDuration = 200,
    this.selectedOverlayColor = const Color(0x669E9E9E),
    this.selectedThemeIcon = const Icon(Icons.check, color: Colors.white),
  }) {
    assert(innerCircleRadius <= 20, "Inner circle max radius exceeds is 20px");
  }

  @override
  Widget build(BuildContext context) {
    String currentThemeId = ThemeProvider.themeOf(context).id;

    return SimpleDialog(
      title: title,
      children: ThemeProvider.controllerOf(context)
          .allThemes
          .map<Widget>(
              (theme) => _buildThemeTile(context, theme, currentThemeId))
          .toList(),
    );
  }

  /// Capitalize the first letter
  String _capitalize(String s) {
    if (s.length == 0) {
      return s;
    } else if (s.length == 1) {
      return s.toUpperCase();
    } else {
      return s[0].toUpperCase() + s.substring(1);
    }
  }

  /// Builds a theme tile
  Widget _buildThemeTile(
    BuildContext context,
    AppTheme theme,
    String currentThemeId,
  ) {
    String themeName = theme.id.split("_").map(_capitalize).join(" ");

    return ListTile(
      leading: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: outerCircleColorBuilder != null
                ? outerCircleColorBuilder(theme)
                : theme.data.accentColor,
            child: CircleAvatar(
              backgroundColor: innerCircleColorBuilder != null
                  ? innerCircleColorBuilder(theme)
                  : theme.data.primaryColor,
              radius: innerCircleRadius,
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: animatedOpacityDuration),
            opacity: theme.id == currentThemeId ? 1 : 0,
            child: CircleAvatar(
              backgroundColor: selectedOverlayColor,
              child: selectedThemeIcon,
            ),
          ),
        ],
      ),
      title: Text(themeName),
      subtitle: hasDescription ? Text(theme.description) : null,
      onTap: () => ThemeProvider.controllerOf(context).setTheme(theme.id),
    );
  }
}
