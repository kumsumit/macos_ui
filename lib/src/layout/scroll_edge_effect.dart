import 'dart:ui';

import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// The edge where a [MacosScrollEdgeEffect] appears.
enum MacosScrollEdge {
  /// The top edge of the content.
  top,

  /// The bottom edge of the content.
  bottom,
}

/// The visual strength of a [MacosScrollEdgeEffect].
enum MacosScrollEdgeStyle {
  /// A subtle fade and blur for controls with their own background.
  soft,

  /// A stronger boundary for interactive text and backgroundless controls.
  hard,
}

/// Clarifies the boundary where scrolling content passes under floating UI.
///
/// In macOS 26, use one scroll edge effect per view beneath floating controls,
/// such as a toolbar or [MacosSplitViewItemAccessory]. Keep effects in adjacent
/// split panes aligned to the same [extent].
class MacosScrollEdgeEffect extends StatelessWidget {
  /// Creates a scroll edge effect layered over [child].
  const MacosScrollEdgeEffect({
    super.key,
    required this.child,
    this.edge = MacosScrollEdge.top,
    this.style = MacosScrollEdgeStyle.hard,
    this.extent = 24.0,
    this.color,
  }) : assert(extent >= 0);

  /// The scrolling content behind the effect.
  final Widget child;

  /// The edge where the effect appears.
  final MacosScrollEdge edge;

  /// The visual strength of the effect.
  final MacosScrollEdgeStyle style;

  /// The height of the effect.
  final double extent;

  /// An optional tint color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    final isHard = style == MacosScrollEdgeStyle.hard;
    final tint =
        color ??
        brightness.resolve(
          Colors.white.withValues(alpha: isHard ? 0.54 : 0.24),
          Colors.black.withValues(alpha: isHard ? 0.48 : 0.2),
        )!;
    final transparentTint = tint.withValues(alpha: 0);
    final colors = edge == MacosScrollEdge.top
        ? [tint, transparentTint]
        : [transparentTint, tint];

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned(
          top: edge == MacosScrollEdge.top ? 0 : null,
          bottom: edge == MacosScrollEdge.bottom ? 0 : null,
          left: 0,
          right: 0,
          height: extent,
          child: IgnorePointer(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: isHard ? 12 : 8,
                  sigmaY: isHard ? 12 : 8,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: colors,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
