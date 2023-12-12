import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_school/models/option.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/models/user.dart';

class Instructor {
  final UserModel userModel;
  final String username;
  final String firstName;
  final String lastName;
  final SelectionOption? grade;
  final SelectionOption? section;
  final List<Subject>? subject;
  final SelectionOption? strand;
  final Timestamp createdAt;

  Instructor({
    required this.userModel,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.grade,
    this.section,
    this.subject,
    this.strand,
    required this.createdAt,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      userModel: UserModel.fromJson(json["userModel"]),
      username: json["username"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      grade: SelectionOption?.fromJson(json["grade"]),
      section: SelectionOption?.fromJson(json["section"]),
      subject: json["subject"] == null
          ? []
          : List<Subject>.from(json["subject"].map((e) => Subject.fromJson(e))),
      strand: json["strand"] != null
          ? SelectionOption?.fromJson(json["strand"])
          : null,
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userModel": userModel.toJson(),
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "grade": grade!.toJson(),
        "section": section!.toJson(),
        "subject": subject!.map((e) => e.toJson()).toList(),
        "strand": strand?.toJson(),
        "createdAt": createdAt,
      };
}
