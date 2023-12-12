class UserModel {
  UserModel({
    required this.controlNumber,
    required this.type,
    required this.id,
    required this.password,
  });

  final String controlNumber;
  final String type;
  final String id;
  final String password;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      controlNumber: json["controlNumber"],
      type: json["type"],
      id: json["id"],
      password: json["password"]
    );
  }

  Map<String, dynamic> toJson() => {
    "controlNumber": controlNumber,
    "type": type,
    "id": id,
    "password": password,
  };
}