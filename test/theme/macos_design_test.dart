import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  test('creates capsule geometry from control height', () {
    expect(
      MacosDesign.capsuleBorderRadius(26),
      const BorderRadius.all(Radius.circular(13)),
    );
  });

  test('keeps nested concentric radii non-negative', () {
    expect(MacosDesign.concentricRadius(parentRadius: 12, inset: 4), 8);
    expect(MacosDesign.concentricRadius(parentRadius: 4, inset: 12), 0);
  });

  testWidgets('builds a liquid glass functional-layer surface', (tester) async {
    await tester.pumpWidget(
      MacosApp(home: const MacosLiquidGlass(child: Text('Glass'))),
    );

    expect(find.byType(MacosLiquidGlass), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('Glass'), findsOneWidget);
  });
}
