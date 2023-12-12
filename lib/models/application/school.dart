// To parse this JSON data, do
//
//     final schoolInfo = schoolInfoFromJson(jsonString);

import 'package:web_school/models/option.dart';

class SchoolInfo {
  SelectionOption schoolYear;
  SelectionOption gradeToEnroll;
  SelectionOption lastGradeCompleted;
  SelectionOption lastSchoolYear;
  SelectionOption residency;
  String nameOfSchool;
  String schoolId;
  String schoolAddress;
  SelectionOption schoolType;
  SelectionOption isPSASubmitted;
  String birthCertificate;
  SelectionOption otherRequirements;
  SelectionOption? semester;
  String track;
  SelectionOption? strand;

  SchoolInfo({
    required this.schoolYear,
    required this.gradeToEnroll,
    required this.lastGradeCompleted,
    required this.lastSchoolYear,
    required this.residency,
    required this.nameOfSchool,
    required this.schoolId,
    required this.schoolAddress,
    required this.schoolType,
    required this.isPSASubmitted,
    required this.birthCertificate,
    required this.otherRequirements,
    this.semester,
    required this.track,
    this.strand,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) => SchoolInfo(
        birthCertificate: json["birthCertificate"] as String,
        gradeToEnroll: SelectionOption.fromJson(json["gradeToEnroll"]),
        isPSASubmitted: SelectionOption.fromJson(json["isPSASubmitted"]),
        lastGradeCompleted:
            SelectionOption.fromJson(json["lastGradeCompleted"]),
        lastSchoolYear: SelectionOption.fromJson(json["lastSchoolYear"]),
        nameOfSchool: json["nameOfSchool"] as String,
        otherRequirements: SelectionOption.fromJson(json["otherRequirements"]),
        residency: SelectionOption.fromJson(json["residency"]),
        schoolAddress: json["schoolAddress"] as String,
        schoolId: json["schoolId"] as String,
        schoolType: SelectionOption.fromJson(json["schoolType"]),
        schoolYear: SelectionOption.fromJson(json["schoolYear"]),
        semester: SelectionOption?.fromJson(json["semester"]),
        strand: SelectionOption?.fromJson(json["strand"]),
        track: json["track"] as String,
      );

  Map<String, dynamic> toJson() => {
        "schoolYear": schoolYear.toJson(),
        "gradeToEnroll": gradeToEnroll.toJson(),
        "residency": residency.toJson(),
        "lastGradeCompleted": lastGradeCompleted.toJson(),
        "lastSchoolYear": lastSchoolYear.toJson(),
        "nameOfSchool": nameOfSchool,
        "schoolId": schoolId,
        "schoolAddress": schoolAddress,
        "schoolType": schoolType.toJson(),
        "isPSASubmitted": isPSASubmitted.toJson(),
        "birthCertificate": birthCertificate,
        "otherRequirements": otherRequirements.toJson(),
        "semester": semester?.toJson(),
        "track": track,
        "strand": strand?.toJson(),
      };
}
