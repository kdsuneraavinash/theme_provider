import 'package:flutter/material.dart';
import 'package:theme_provider/src/controller/theme_controller.dart';

/// Object which provides the [ThemeController] down the widget tree.
class InheritedThemeController extends InheritedNotifier<ThemeController> {
  final ThemeController controller;

  /// Constructs a [InheritedWidget] which provides the [ThemeController] down the widget tree.
  const InheritedThemeController(
      {Key? key, required Widget child, required this.controller})
      : super(key: key, child: child, notifier: controller);

  /// Gets the reference to [ThemeController] directly.
  /// This also provides references to current theme and other objects.
  /// So this class is not exported.
  /// Only the classes inside this package can use this.
  /// There should be a [ThemeController] above this widget.
  /// Otherwise this will throw an assertion error.
  static ThemeController of(BuildContext context) {
    ThemeController? controller = context
        .dependOnInheritedWidgetOfExactType<InheritedThemeController>()
        ?.controller;
    assert(controller != null,
        "Could not find a theme controller in the widget tree");
    return controller!;
  }
}
