import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// The edge where a [MacosSplitViewItemAccessory] appears.
enum MacosSplitViewItemAccessoryAlignment {
  /// Position the accessory above the split item content.
  top,

  /// Position the accessory below the split item content.
  bottom,
}

/// Floating controls that span one item in a split view.
///
/// This mirrors the split item accessory introduced for macOS 26. Place it
/// above or below a split pane and use [MacosScrollEdgeEffect] on the pane's
/// scrolling content to clarify the boundary beneath the accessory.
class MacosSplitViewItemAccessory extends StatelessWidget {
  /// Creates a split-view accessory.
  const MacosSplitViewItemAccessory({
    super.key,
    required this.child,
    this.alignment = MacosSplitViewItemAccessoryAlignment.top,
    this.padding = const EdgeInsets.all(6),
    this.margin = const EdgeInsets.all(8),
    this.color,
  });

  /// The controls displayed in the accessory.
  final Widget child;

  /// The split-item edge where the accessory belongs.
  final MacosSplitViewItemAccessoryAlignment alignment;

  /// The padding inside the glass surface.
  final EdgeInsetsGeometry padding;

  /// The margin around the glass surface.
  final EdgeInsetsGeometry margin;

  /// An optional glass tint color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Align(
        alignment: alignment == MacosSplitViewItemAccessoryAlignment.top
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: Padding(
          padding: margin,
          child: MacosLiquidGlass(
            borderRadius: MacosDesign.capsuleBorderRadius(36),
            color: color,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
