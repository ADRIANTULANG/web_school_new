import 'package:intl/intl.dart';
import 'package:web_school/models/student/schedule.dart';

extension ConvertDate on Schedule {
  DateTime getNextDayTime(Schedule schedule) {
    final now = DateTime.now();
    final daysUntilNextDay = (schedule.day - now.weekday + 7) % 7;
    final nextDay = now.add(Duration(days: daysUntilNextDay));
    return DateTime(
      nextDay.year,
      nextDay.month,
      nextDay.day,
      schedule.start.hour,
      schedule.start.minute,
    );
  }


}

extension DateTimeConvert on DateTime {
  String toDayOfWeek() {
    return DateFormat("EEEE").format(this);
  }
}

