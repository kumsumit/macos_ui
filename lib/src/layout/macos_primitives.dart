import 'package:cupertino_ui/cupertino_ui.dart';

/// A macOS separator used by examples and compatibility code.
class Divider extends StatelessWidget {
  const Divider({super.key, this.color, this.height = 1});
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: color ?? const Color(0x22000000),
        child: SizedBox(height: height),
      );
}

/// macOS route with Cupertino page-transition behavior.
typedef MacosPageRoute<T> = CupertinoPageRoute<T>;

/// Compatibility alias for old example code; uses Cupertino transitions.
typedef MaterialPageRoute<T> = MacosPageRoute<T>;

/// Compatibility alias for old test fixtures; this is a Cupertino app.
typedef MaterialApp = CupertinoApp;

/// Minimal content container for legacy test fixtures.
class Scaffold extends StatelessWidget {
  const Scaffold({super.key, this.body});
  final Widget? body;

  @override
  Widget build(BuildContext context) => body ?? const SizedBox.shrink();
}

abstract final class Colors {
  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color grey = Color(0xff9e9e9e);
  static const Color red = Color(0xfff44336);
  static const Color blue = Color(0xff2196f3);
}
