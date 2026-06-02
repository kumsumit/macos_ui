import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// A logical group of toolbar actions sharing one Liquid Glass surface.
///
/// Group related actions by function and frequency. Keep primary actions and
/// controls with different behavior, such as search and pop-up buttons, in
/// separate groups.
class ToolBarItemGroup extends ToolbarItem {
  /// Creates a toolbar item group.
  const ToolBarItemGroup({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 2),
    this.color,
  }) : assert(children.length > 0);

  /// The related toolbar actions in this group.
  final List<ToolbarItem> children;

  /// Padding inside the shared glass surface.
  final EdgeInsetsGeometry padding;

  /// An optional glass tint color.
  final Color? color;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    if (displayMode == ToolbarItemDisplayMode.overflowed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children
            .map((item) => item.build(context, displayMode))
            .toList(growable: false),
      );
    }

    return MacosLiquidGlass(
      borderRadius: MacosDesign.capsuleBorderRadius(32),
      boxShadow: const [],
      color: color,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children
              .map((item) => item.build(context, displayMode))
              .toList(growable: false),
        ),
      ),
    );
  }
}
