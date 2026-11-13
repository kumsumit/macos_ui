import 'package:flutter/foundation.dart';

/// Controls the compactness of macOS layout components.
///
/// Unlike Material's [VisualDensity], this uses explicit macOS spacing values
/// and does not apply platform-specific adjustments automatically.
@immutable
class MacosControlDensity with Diagnosticable {
  const MacosControlDensity({this.horizontal = 0, this.vertical = 0});

  const MacosControlDensity.standard() : this();

  const MacosControlDensity.compact()
      : horizontal = -2,
        vertical = -2;

  const MacosControlDensity.comfortable()
      : horizontal = 2,
        vertical = 2;

  final double horizontal;
  final double vertical;

  static MacosControlDensity lerp(
    MacosControlDensity a,
    MacosControlDensity b,
    double t,
  ) {
    return MacosControlDensity(
      horizontal: a.horizontal + (b.horizontal - a.horizontal) * t,
      vertical: a.vertical + (b.vertical - a.vertical) * t,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('horizontal', horizontal));
    properties.add(DoubleProperty('vertical', vertical));
  }
}
