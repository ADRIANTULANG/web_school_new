import 'package:equatable/equatable.dart';
import 'package:web_school/models/student/schedule.dart';

class Subject extends Equatable {
  final String name;
  final List<Grade> grades;
  final int? units;
  final String id;
  final List<Schedule>? schedule;

  Subject({
    required this.name,
    required this.grades,
    required this.units,
    required this.id,
    this.schedule,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json["name"],
        grades: List<Grade>.from(json["grades"].map((x) => Grade.fromJson(x))),
        units: json["units"],
        id: json["id"].toString(),
        schedule: json["schedule"] == null
            ? []
            : List<Schedule>.from(
                json["schedule"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "grades": List<dynamic>.from(grades.map((x) => x.toJson())),
        "units": units,
        "id": id,
        "schedule": schedule == null
            ? []
            : List<dynamic>.from(schedule!.map((e) => e.toJson())),
      };

  @override
  List<Object?> get props => [id];
}

class Grade {
  final String? title;
  final double? grade;

  Grade({
    this.title,
    this.grade,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
        title: json["title"] as String?,
        grade: json["grade"] != null
            ? double.parse(json["grade"].toString())
            : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "grade": grade,
      };
}
