import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  test('macOS typography equality', () {
    expect(
      MacosTypography.lightOpaque(),
      equals(MacosTypography.lightOpaque()),
    );
  });

  test('macOS typography distinguishes text styles', () {
    final typography1 = MacosTypography(
      color: MacosColors.black,
      body: const TextStyle(fontSize: 10),
    );
    final typography2 = MacosTypography(
      color: MacosColors.black,
      body: const TextStyle(fontSize: 12),
    );

    expect(typography1, isNot(equals(typography2)));
  });

  test('macOS typography supports light and dark presets', () {
    expect(
      MacosTypography.lightOpaque(),
      isNot(equals(MacosTypography.darkOpaque())),
    );
  });
}
