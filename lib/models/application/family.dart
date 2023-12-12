
import 'package:web_school/models/option.dart';

class FamilyInfo {
  final SelectionOption responsible;
  final SelectionOption parentStatus;
  final String numberOfBrother;
  final String numberOfSister;
  final String birthNumber;
  final SelectionOption beneficiary;
  final String whenBeneficiary;
  final String firstName;
  final String middleName;
  final String lastName;
  final String relationship;
  final String dateEntered;

  FamilyInfo({
    required this.responsible,
    required this.parentStatus,
    required this.numberOfBrother,
    required this.numberOfSister,
    required this.birthNumber,
    required this.beneficiary,
    required this.whenBeneficiary,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.relationship,
    required this.dateEntered,
  });


  factory FamilyInfo.fromJson(Map<String, dynamic> json) => FamilyInfo(
    responsible: SelectionOption.fromJson(json["responsible"]),
    parentStatus: SelectionOption.fromJson(json["parentStatus"]),
    numberOfBrother: json["numberOfBrother"],
    numberOfSister: json["numberOfSister"],
    birthNumber: json["birthNumber"],
    beneficiary: SelectionOption.fromJson(json["beneficiary"]),
    whenBeneficiary: json["whenBeneficiary"],
    firstName: json["firstName"],
    middleName: json["middleName"],
    lastName: json["lastName"],
    relationship: json["relationship"],
    dateEntered: json["dateEntered"],
  );

  Map<String, dynamic> toJson() => {
    "responsible": responsible.toJson(),
    "parentStatus": parentStatus.toJson(),
    "numberOfBrother": numberOfBrother,
    "numberOfSister": numberOfSister,
    "birthNumber": birthNumber,
    "beneficiary": beneficiary.toJson(),
    "whenBeneficiary": whenBeneficiary,
    "firstName": firstName,
    "middleName": middleName,
    "lastName": lastName,
    "relationship": relationship,
    "dateEntered": dateEntered,
  };
}
