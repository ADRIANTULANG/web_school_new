// To parse this JSON data, do
//
//     final residence = residenceFromJson(jsonString);

import 'dart:convert';

import 'package:web_school/models/option.dart';

ResidenceInfo residenceFromJson(String str) => ResidenceInfo.fromJson(json.decode(str));

String residenceToJson(ResidenceInfo data) => json.encode(data.toJson());

class ResidenceInfo {
  SelectionOption household;
  Address currentAddress;
  Address familyAddress;
  SelectionOption familyInfo;


  ResidenceInfo({
    required this.household,
    required this.currentAddress,
    required this.familyAddress,
    required this.familyInfo,

  });

  factory ResidenceInfo.fromJson(Map<String, dynamic> json) => ResidenceInfo(
    household: SelectionOption.fromJson(json["household"]),
    currentAddress: Address.fromJson(json["currentAddress"]),
    familyAddress: Address.fromJson(json["familyAddress"]),
    familyInfo: SelectionOption.fromJson(json["familyInfo"]) ,

  );

  Map<String, dynamic> toJson() => {
    "household": household.toJson(),
    "currentAddress": currentAddress.toJson(),
    "familyAddress": familyAddress.toJson(),
    "familyInfo": familyInfo.toJson(),

  };
}

class Address {
  String address;
  String barangay;
  String city;
  String province;
  String region;

  Address({
    required this.address,
    required this.barangay,
    required this.city,
    required this.province,
    required this.region,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    barangay: json["barangay"],
    city: json["city"],
    province: json["province"],
    region: json["region"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "barangay": barangay,
    "city": city,
    "province": province,
    "region": region,
  };
}
