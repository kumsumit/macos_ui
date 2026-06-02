import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// {@template macosOverlayFilter}
/// Applies a blur filter to its child to create a macOS-style "frosted glass"
/// effect.
/// {@endtemplate}
class MacosOverlayFilter extends StatelessWidget {
  /// {@macro macosOverlayFilter}
  ///
  /// Used mainly for the overlays that appear from various macOS-style widgets,
  /// like the pull-down and pop-up buttons, or the search field.
  const MacosOverlayFilter({
    super.key,
    required this.child,
    required this.borderRadius,
    this.color,
  });

  /// The widget to apply the blur filter to.
  final Widget child;

  /// The border radius to use when applying the effect to the
  /// child widget.
  final BorderRadius borderRadius;

  /// The color to use as the filter's background.
  ///
  /// If it is null, the macOS default surface background
  /// colors will be used.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MacosLiquidGlass(
      borderRadius: borderRadius,
      style: MacosLiquidGlassStyle.prominent,
      color: color,
      child: child,
    );
  }
}
