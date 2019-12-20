import 'package:flutter/material.dart';
import 'package:theme_provider/src/controller/theme_controller.dart';

/// Object which provides the [ThemeController] down the widget tree.
class InheritedThemeController extends InheritedNotifier<ThemeController> {
  final ThemeController controller;

  /// Constructs a [InheritedWidget] which provides the [ThemeController] down the widget tree.
  const InheritedThemeController({Key key, Widget child, this.controller})
      : super(key: key, child: child, notifier: controller);

  /// Gets the reference to [ThemeController] directly.
  /// This also provides references to current theme and other objects.
  /// So this class is not exported.
  /// Only the classes inside this package can use this.
  static ThemeController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedThemeController>()
        .controller;
  }
}
