import 'package:flutter/foundation.dart';

/// Theme selection for [MacosApp].
enum ThemeMode { system, light, dark }

enum DayPeriod { am, pm }

/// A platform-independent time value used by the macOS time picker.
@immutable
class TimeOfDay {
  const TimeOfDay({required this.hour, required this.minute})
      : assert(hour >= 0 && hour < 24),
        assert(minute >= 0 && minute < 60);

  factory TimeOfDay.now() {
    final now = DateTime.now();
    return TimeOfDay(hour: now.hour, minute: now.minute);
  }

  final int hour;
  final int minute;

  DayPeriod get period => hour < 12 ? DayPeriod.am : DayPeriod.pm;

  @override
  bool operator ==(Object other) =>
      other is TimeOfDay && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}

/// Calendar helpers used by the macOS date picker.
abstract final class DateUtils {
  static int getDaysInMonth(int year, int month) {
    if (month == 12) return DateTime(year + 1, 1, 0).day;
    return DateTime(year, month + 1, 0).day;
  }

  static bool isSameDay(DateTime? a, DateTime? b) =>
      a?.year == b?.year && a?.month == b?.month && a?.day == b?.day;

  static int firstDayOffset(int year, int month, int firstDayOfWeekIndex) {
    final weekday = DateTime(year, month, 1).weekday % 7;
    return (weekday - firstDayOfWeekIndex + 7) % 7;
  }
}
