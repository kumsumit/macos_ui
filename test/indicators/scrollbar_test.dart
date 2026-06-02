import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  const double thicknessWhenDragging = 9;

  testWidgets('Scrollbar changes position when scrolled with the mouse wheel', (
    tester,
  ) async {
    final scrollController = ScrollController();
    final Size screenSize =
        tester.view.physicalSize / tester.view.devicePixelRatio;

    await tester.pumpWidget(_scrollbar(scrollController, screenSize));

    const Offset scrollAmount = Offset(0.0, 5.0);
    const Offset reverseScrollAmount = Offset(0.0, -5.0);
    Offset finalPosition = Offset.zero;
    final Offset scrollEventLocation = tester.getCenter(
      find.byType(SingleChildScrollView),
    );
    final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);

    testPointer.hover(scrollEventLocation);

    // Scroll down
    await tester.sendEventToBinding(testPointer.scroll(scrollAmount));
    await tester.pumpAndSettle();
    expect(scrollController.offset, scrollAmount.dy);
    // Scroll back up
    await tester.sendEventToBinding(testPointer.scroll(reverseScrollAmount));
    await tester.pumpAndSettle();
    expect(scrollController.offset, finalPosition.dy);
  });

  testWidgets('Scrollbar changes position when scrolled with a trackpad', (
    tester,
  ) async {
    final scrollController = ScrollController();
    final Size screenSize =
        tester.view.physicalSize / tester.view.devicePixelRatio;
    await tester.pumpWidget(_scrollbar(scrollController, screenSize));

    final trackpad = TestPointer(1, PointerDeviceKind.trackpad);
    trackpad.hover(tester.getCenter(find.byType(SingleChildScrollView)));

    await tester.sendEventToBinding(trackpad.scroll(const Offset(0, 5)));
    await tester.pumpAndSettle();

    expect(scrollController.offset, 5);
  });

  testWidgets('Scrollbar changes position after a trackpad fling', (
    tester,
  ) async {
    final scrollController = ScrollController();
    final Size screenSize =
        tester.view.physicalSize / tester.view.devicePixelRatio;
    await tester.pumpWidget(_scrollbar(scrollController, screenSize));

    await tester.trackpadFling(
      find.byType(SingleChildScrollView),
      const Offset(0, -100),
      500,
    );
    await tester.pumpAndSettle();

    expect(scrollController.offset, greaterThan(0));
  });

  testWidgets('Scrollbar expands on hover and can be dragged', (tester) async {
    final scrollController = ScrollController();
    final Size screenSize =
        tester.view.physicalSize / tester.view.devicePixelRatio;
    await tester.pumpWidget(_scrollbar(scrollController, screenSize));
    await tester.pumpAndSettle();

    final dynamic scrollbarState = tester.state(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == '_RawMacosScrollBar',
      ),
    );
    final scrollbarLocation = _scrollbarLocation(tester, scrollbarState);
    scrollbarState.handleHover(
      PointerHoverEvent(
        position: scrollbarLocation,
        kind: PointerDeviceKind.mouse,
      ),
    );
    await tester.pumpAndSettle();

    final painter = _scrollbarPainter(tester);
    expect(painter.thickness, thicknessWhenDragging);
    expect(painter.trackColor, isNot(MacosColors.transparent));

    await tester.dragFrom(
      _scrollbarThumbLocation(tester, scrollbarState),
      const Offset(0, 50),
    );
    await tester.pumpAndSettle();

    expect(scrollController.offset, greaterThan(0));
  });
}

Widget _scrollbar(ScrollController scrollController, Size screenSize) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: PrimaryScrollController(
        controller: scrollController,
        child: MacosTheme(
          data: MacosThemeData.light(),
          child: MacosScrollbar(
            thumbVisibility: true,
            thickness: 6,
            thicknessWhileHovering: 9,
            child: SingleChildScrollView(
              child: SizedBox(
                width: screenSize.width * 2,
                height: screenSize.height * 2,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

ScrollbarPainter _scrollbarPainter(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .map((customPaint) => customPaint.foregroundPainter)
      .whereType<ScrollbarPainter>()
      .single;
}

Offset _scrollbarLocation(WidgetTester tester, dynamic scrollbarState) {
  return _findScrollbarLocation(
    tester,
    (position) => scrollbarState.isPointerOverScrollbar(
      position,
      PointerDeviceKind.mouse,
      forHover: true,
    ),
  );
}

Offset _scrollbarThumbLocation(WidgetTester tester, dynamic scrollbarState) {
  return _findScrollbarLocation(
    tester,
    (position) =>
        scrollbarState.isPointerOverThumb(position, PointerDeviceKind.mouse),
  );
}

Offset _findScrollbarLocation(
  WidgetTester tester,
  bool Function(Offset position) hitTest,
) {
  final paintFinder = find.byWidgetPredicate(
    (widget) =>
        widget is CustomPaint && widget.foregroundPainter is ScrollbarPainter,
  );
  final rect = tester.getRect(paintFinder);

  for (double y = rect.top; y < rect.bottom; y++) {
    for (double x = rect.left; x < rect.right; x++) {
      final position = Offset(x, y);
      if (hitTest(position)) {
        return position;
      }
    }
  }

  throw StateError('Could not find an interactive scrollbar location.');
}
