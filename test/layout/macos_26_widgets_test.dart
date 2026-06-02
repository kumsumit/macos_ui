import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  testWidgets('scroll edge effect layers a blur over content', (tester) async {
    await tester.pumpWidget(
      MacosApp(
        home: const SizedBox(
          height: 100,
          child: MacosScrollEdgeEffect(child: Text('Content')),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('split item accessory uses a liquid glass surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MacosApp(
        home: const MacosSplitViewItemAccessory(child: Text('Accessory')),
      ),
    );

    expect(find.byType(MacosLiquidGlass), findsOneWidget);
    expect(find.text('Accessory'), findsOneWidget);
  });

  testWidgets('inspector uses edge-to-edge liquid glass', (tester) async {
    await tester.pumpWidget(
      MacosApp(home: const MacosInspector(child: Text('Inspector'))),
    );

    final glass = tester.widget<MacosLiquidGlass>(
      find.byType(MacosLiquidGlass),
    );
    expect(glass.borderRadius, BorderRadius.zero);
    expect(find.text('Inspector'), findsOneWidget);
  });

  testWidgets('background extension keeps readable content in a safe area', (
    tester,
  ) async {
    await tester.pumpWidget(
      MacosApp(
        home: const MacosBackgroundExtension(
          background: ColoredBox(color: Color(0xff123456)),
          child: Text('Readable'),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(MacosBackgroundExtension),
        matching: find.byType(ExcludeSemantics),
      ),
      findsOneWidget,
    );
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.text('Readable'), findsOneWidget);
  });

  testWidgets('toolbar item group shares one liquid glass surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MacosApp(
        home: Builder(
          builder: (context) => ToolBarItemGroup(
            children: [
              CustomToolbarItem(inToolbarBuilder: (_) => const Text('One')),
              CustomToolbarItem(inToolbarBuilder: (_) => const Text('Two')),
            ],
          ).build(context, ToolbarItemDisplayMode.inToolbar),
        ),
      ),
    );

    expect(find.byType(MacosLiquidGlass), findsOneWidget);
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
  });

  test('extra large push button uses a prominent capsule', () {
    expect(
      ControlSize.extraLarge.borderRadius,
      const BorderRadius.all(Radius.circular(16)),
    );
  });
}
