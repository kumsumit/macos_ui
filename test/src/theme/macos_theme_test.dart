import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/src/theme/help_button_theme.dart';
import 'package:macos_ui/src/theme/date_picker_theme.dart';
import 'package:macos_ui/src/theme/macos_colors.dart';
import 'package:macos_ui/src/theme/macos_theme.dart';
import 'package:macos_ui/src/theme/time_picker_theme.dart';

void main() {
  testWidgets('macos theme MacosThemeData equality 1', (tester) async {
    final macosThemeData1 = MacosThemeData();
    final macosThemeData2 = MacosThemeData();

    expect(macosThemeData1, equals(macosThemeData2));
  });

  testWidgets('macos theme MacosThemeData equality 2', (tester) async {
    final macosThemeData1 = MacosThemeData(brightness: Brightness.dark);
    final macosThemeData2 = MacosThemeData(brightness: Brightness.light);

    expect(macosThemeData1, isNot(equals(macosThemeData2)));
  });

  testWidgets('macos theme MacosThemeData equality 3', (tester) async {
    final macosThemeData1 = MacosThemeData(
      helpButtonTheme: const HelpButtonThemeData(color: MacosColors.appleRed),
    );

    final macosThemeData2 = MacosThemeData(
      helpButtonTheme: const HelpButtonThemeData(color: MacosColors.appleGreen),
    );

    expect(macosThemeData1, isNot(equals(macosThemeData2)));
  });

  testWidgets('macos theme MacosThemeData equality 4', (tester) async {
    final macosThemeData1 = MacosThemeData(
      helpButtonTheme: const HelpButtonThemeData(color: MacosColors.appleRed),
    );

    final macosThemeData2 = MacosThemeData(
      helpButtonTheme: const HelpButtonThemeData(color: MacosColors.appleRed),
    );

    expect(macosThemeData1, equals(macosThemeData2));
  });

  test('preserves custom picker themes', () {
    final datePickerTheme = MacosDatePickerThemeData(
      backgroundColor: MacosColors.appleRed,
    );
    final timePickerTheme = MacosTimePickerThemeData(
      backgroundColor: MacosColors.appleGreen,
    );

    final theme = MacosThemeData(
      datePickerTheme: datePickerTheme,
      timePickerTheme: timePickerTheme,
    );

    expect(theme.datePickerTheme.backgroundColor, MacosColors.appleRed);
    expect(theme.timePickerTheme.backgroundColor, MacosColors.appleGreen);
  });

  test('interpolates canvas colors independently from primary colors', () {
    const lightCanvas = MacosColors.appleRed;
    const darkCanvas = MacosColors.appleGreen;

    final theme = MacosThemeData.lerp(
      MacosThemeData.light().copyWith(canvasColor: lightCanvas),
      MacosThemeData.dark().copyWith(canvasColor: darkCanvas),
      0.0,
    );

    expect(theme.canvasColor, lightCanvas);
  });
}
