import 'package:flutter/material.dart';
import 'package:web_school/models/student/subject.dart';

class SeniorGradeScreen extends StatelessWidget {
  const SeniorGradeScreen({
    required this.subjectList,
    super.key,
  });

  final List<Subject> subjectList;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double gwa = 0;

    double totalGrade = subjectList.fold(0, (sum, grade) => sum + grade.grades.first.grade!);
    gwa = totalGrade / subjectList.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Name",
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text("Grade",
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          ListView.builder(
            itemCount: subjectList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subjectList[index].name),
                      Text("${subjectList[index].grades.first.grade}"),
                    ],
                  ),
                  Divider(),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("GWA: ${gwa.toStringAsFixed(2)}",
            ),
          ),
        ],
      ),
    );
  }
}
