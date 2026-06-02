import 'dart:ui';

import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/wallpaper_tinting_settings/wallpaper_tinting_override.dart';
import 'package:macos_ui/src/library.dart';

/// Shared geometry for the macOS 26 design language.
///
/// Fixed radii keep dense desktop controls compact. Capsule radii are intended
/// for prominent controls, such as large push buttons.
abstract final class MacosDesign {
  /// The default radius for compact controls.
  static const double controlRadius = 7.0;

  /// The default radius for menus, popovers, and other floating surfaces.
  static const double overlayRadius = 12.0;

  /// Returns a capsule-shaped border radius for the given [height].
  static BorderRadius capsuleBorderRadius(double height) {
    return BorderRadius.all(Radius.circular(height / 2));
  }

  /// Returns the radius of a child shape nested inside [parentRadius].
  static double concentricRadius({
    required double parentRadius,
    required double inset,
  }) {
    return (parentRadius - inset).clamp(0.0, double.infinity);
  }
}

/// The visual strength of a [MacosLiquidGlass] surface.
enum MacosLiquidGlassStyle {
  /// A lightweight surface for controls and navigation.
  regular,

  /// A more opaque surface for menus, sheets, and overlays.
  prominent,
}

/// A macOS 26-style Liquid Glass surface for controls and navigation.
///
/// Liquid Glass belongs in the functional layer above content. Use standard
/// materials, such as [WallpaperTintedArea], for content backgrounds.
class MacosLiquidGlass extends StatelessWidget {
  /// Creates a Liquid Glass surface.
  const MacosLiquidGlass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(MacosDesign.overlayRadius),
    ),
    this.style = MacosLiquidGlassStyle.regular,
    this.color,
    this.borderColor,
    this.boxShadow,
  });

  /// The widget displayed on top of the material.
  final Widget child;

  /// The radius of the material and its clipped content.
  final BorderRadius borderRadius;

  /// The visual strength of the surface.
  final MacosLiquidGlassStyle style;

  /// An optional tint color.
  final Color? color;

  /// An optional border color.
  final Color? borderColor;

  /// Optional shadows. Defaults to a subtle elevation shadow.
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    final isProminent = style == MacosLiquidGlassStyle.prominent;
    final tint =
        color ??
        brightness.resolve(
          Color.fromRGBO(255, 255, 255, isProminent ? 0.72 : 0.42),
          Color.fromRGBO(30, 30, 30, isProminent ? 0.78 : 0.56),
        );
    final outline =
        borderColor ??
        brightness.resolve(
          Colors.white.withValues(alpha: isProminent ? 0.72 : 0.52),
          Colors.white.withValues(alpha: isProminent ? 0.2 : 0.14),
        )!;

    return WallpaperTintingOverride(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tint,
          border: Border.all(color: outline, width: 0.75),
          borderRadius: borderRadius,
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isProminent ? 0.2 : 0.12,
                  ),
                  offset: const Offset(0, 4),
                  blurRadius: isProminent ? 14 : 10,
                ),
              ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isProminent ? 24 : 18,
              sigmaY: isProminent ? 24 : 18,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
