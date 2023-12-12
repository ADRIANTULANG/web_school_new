import 'package:flutter/material.dart';
import 'package:web_school/models/student/subject.dart';

class JuniorGradeScreen extends StatelessWidget {
  const JuniorGradeScreen({
    required this.subjectList,
    super.key,
  });

  final List<Subject> subjectList;

  @override
  Widget build(BuildContext context) {
    return Text("Hi");
  }
}
