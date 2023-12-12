class Schedule {
  Schedule({
    required this.day,
    required this.start,
  });

  final int day;
  final TimeData start;

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      day: json["day"],
      start: TimeData.fromJson(json["start"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "day": day,
        "start": start.toJson(),
      };
}

class TimeData {
  TimeData({
    required this.hour,
    required this.minute,
  });

  final int hour;
  final int minute;

  factory TimeData.fromJson(Map<String, dynamic> json) {
    return TimeData(
      hour: json["hour"],
      minute: json["minute"],
    );
  }

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
}
