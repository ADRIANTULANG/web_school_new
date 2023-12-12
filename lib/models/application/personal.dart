// To parse this JSON data, do
//
//     final personalInfo = personalInfoFromJson(jsonString);

import 'dart:convert';

import 'package:web_school/models/option.dart';

PersonalInfo personalInfoFromJson(String str) => PersonalInfo.fromJson(json.decode(str));

String personalInfoToJson(PersonalInfo data) => json.encode(data.toJson());

class PersonalInfo {
  SelectionOption hasLrn;
  String lrn;
  String lastName;
  String firstName;
  String middleName;
  String extensionName;
  String placeOfBirth;
  String dateOfBirth;
  String age;
  SelectionOption gender;
  SelectionOption? isIndigenous;
  String motherTounge;
  String otherLanguage;

  PersonalInfo({
    required this.hasLrn,
    required this.lrn,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    required this.extensionName,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.isIndigenous,
    required this.motherTounge,
    required this.otherLanguage,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    hasLrn: SelectionOption.fromJson(json["hasLrn"]),
    lrn: json["lrn"],
    lastName: json["lastName"],
    firstName: json["firstName"],
    middleName: json["middleName"],
    extensionName: json["extensionName"],
    placeOfBirth: json["placeOfBirth"],
    dateOfBirth: json["dateOfBirth"],
    age: json["age"],
    gender: SelectionOption.fromJson(json["gender"]),
    isIndigenous: SelectionOption?.fromJson(json["isIndigenous"]),
    motherTounge: json["motherTounge"],
    otherLanguage: json["otherLanguage"],
  );

  Map<String, dynamic> toJson() => {
    "hasLrn": hasLrn.toJson(),
    "lrn": lrn,
    "lastName": lastName,
    "firstName": firstName,
    "middleName": middleName,
    "extensionName": extensionName,
    "placeOfBirth": placeOfBirth,
    "dateOfBirth": dateOfBirth,
    "age": age,
    "gender": gender.toJson(),
    "isIndigenous": isIndigenous?.toJson(),
    "motherTounge": motherTounge,
    "otherLanguage": otherLanguage,
  };
}
