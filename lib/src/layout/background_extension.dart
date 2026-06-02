import 'package:macos_ui/src/library.dart';

/// Extends a decorative background edge-to-edge behind floating UI.
///
/// This mirrors the role of `NSBackgroundExtensionView` in macOS 26. Use
/// [background] for expansive artwork, tint, or decoration and place readable
/// text and controls in [child], which remains inside the safe area.
class MacosBackgroundExtension extends StatelessWidget {
  /// Creates a background extension.
  const MacosBackgroundExtension({
    super.key,
    required this.background,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  /// The decorative content extended behind floating UI.
  final Widget background;

  /// The readable content positioned inside the safe area.
  final Widget child;

  /// Additional padding around [child].
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(child: background),
        SafeArea(
          child: Padding(padding: padding, child: child),
        ),
      ],
    );
  }
}
