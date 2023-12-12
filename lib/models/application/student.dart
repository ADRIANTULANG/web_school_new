class StudentInfo {

  final String name;
  final String section;
  final bool enrolled;
  final bool isTransferee;

  StudentInfo({

    required this.name,
    required this.section,
    required this.enrolled,
    required this.isTransferee,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
    name: json["name"],
    section: json["section"],
    enrolled: json["enrolled"],
    isTransferee: json["isTransferee"],
  );


  Map<String, dynamic> toJson() => {
        "name": name,
        "section": section,
        "enrolled": enrolled,
        "isTransferee": isTransferee,
      };
}
