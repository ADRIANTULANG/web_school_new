import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_school/models/application/emergency.dart';
import 'package:web_school/models/application/family.dart';
import 'package:web_school/models/application/personal.dart';
import 'package:web_school/models/application/residence.dart';
import 'package:web_school/models/application/school.dart';
import 'package:web_school/models/application/student.dart';
import 'package:web_school/models/user.dart';

import 'dart:convert';

List<ApplicationInfo> applicationFromJson(String str) =>
    List<ApplicationInfo>.from(
        json.decode(str).map((x) => ApplicationInfo.fromJson(x)));

class ApplicationInfo {
  ApplicationInfo({
    required this.userModel,
    required this.studentInfo,
    required this.schoolInfo,
    required this.personalInfo,
    required this.emergencyInfo,
    required this.residenceInfo,
    required this.familyInfo,
    required this.createdAt,
  });

  final UserModel userModel;
  final StudentInfo studentInfo;
  final SchoolInfo schoolInfo;
  final PersonalInfo personalInfo;
  final EmergencyInfo emergencyInfo;
  final ResidenceInfo residenceInfo;
  final FamilyInfo familyInfo;
  final Timestamp createdAt;

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) {
    return ApplicationInfo(
      userModel: UserModel.fromJson(json["userModel"]),
      studentInfo: StudentInfo.fromJson(json["studentInfo"]),
      schoolInfo: SchoolInfo.fromJson(json["schoolInfo"]),
      personalInfo: PersonalInfo.fromJson(json["personalInfo"]),
      emergencyInfo: EmergencyInfo.fromJson(json["emergencyInfo"]),
      residenceInfo: ResidenceInfo.fromJson(json["residenceInfo"]),
      familyInfo: FamilyInfo.fromJson(json["familyInfo"]),
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        'userModel': userModel.toJson(),
        'studentInfo': studentInfo.toJson(),
        'schoolInfo': schoolInfo.toJson(),
        'personalInfo': personalInfo.toJson(),
        'emergencyInfo': emergencyInfo.toJson(),
        'residenceInfo': residenceInfo.toJson(),
        'familyInfo': familyInfo.toJson(),
        'createdAt': createdAt,
      };
}
