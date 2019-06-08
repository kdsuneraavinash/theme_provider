import 'package:flutter/material.dart';
import 'package:theme_provider/src/controller/theme_controller.dart';

/// Object which provides the [ThemeController] down the widget tree.
class InheritedThemeController extends InheritedNotifier<ThemeController> {
  final ThemeController controller;

  const InheritedThemeController({Key key, Widget child, this.controller})
      : super(key: key, child: child, notifier: controller);

  static ThemeController of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedThemeController)
            as InheritedThemeController)
        .controller;
  }
}
