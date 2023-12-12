import 'package:web_school/models/option.dart';

class EmergencyInfo {
  SelectionOption communication;
  String number;
  String firstName;
  String middleName;
  String lastName;
  String emergencyAddress;
  SelectionOption relationship;
  String address;
  String contactNumber;

  EmergencyInfo({
    required this.communication,
    required this.number,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.emergencyAddress,
    required this.relationship,
    required this.address,
    required this.contactNumber,
  });

  factory EmergencyInfo.fromJson(Map<String, dynamic> json) => EmergencyInfo(
        communication: SelectionOption.fromJson(json["communication"]),
        number: json["number"] as String,
        firstName: json["firstName"] as String,
        middleName: json["middleName"] as String,
        lastName: json["lastName"] as String,
        emergencyAddress: json["emergencyAddress"],
        relationship: SelectionOption.fromJson(json['relationship']),
        address: json["address"] as String,
        contactNumber: json["contactNumber"] as String,
      );

  Map<String, dynamic> toJson() => {
        "communication": communication.toJson(),
        "number": number,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "emergencyAddress": emergencyAddress,
        "relationship": relationship.toJson(),
        "address": address,
        "contactNumber": contactNumber,
      };
}
