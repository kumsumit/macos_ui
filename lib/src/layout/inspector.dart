import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

/// An edge-to-edge macOS inspector surface.
///
/// In macOS 26, inspectors use an edge-to-edge glass treatment. Place this
/// widget in a trailing [ResizablePane] when the inspector needs resizing.
class MacosInspector extends StatelessWidget {
  /// Creates an inspector surface.
  const MacosInspector({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.color,
  });

  /// The inspector content.
  final Widget child;

  /// The padding around [child].
  final EdgeInsetsGeometry padding;

  /// An optional glass tint color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: MacosLiquidGlass(
        borderRadius: BorderRadius.zero,
        boxShadow: const [],
        color: color,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
