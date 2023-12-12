import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:web_school/models/application/application.dart';

class StudentPieChart extends StatelessWidget {
  const StudentPieChart({
    required this.studentList,
    super.key,
  });

  final List<ApplicationInfo> studentList;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    double grade7 = 0;
    double grade8 = 0;
    double grade9 = 0;
    double grade10 = 0;
    double grade11 = 0;
    double grade12 = 0;

    for (var data in studentList) {
      if (data.schoolInfo.gradeToEnroll.label!.contains("7")) {
        grade7++;
      } else if (data.schoolInfo.gradeToEnroll.label!.contains("8")) {
        grade8++;
      } else if (data.schoolInfo.gradeToEnroll.label!.contains("9")) {
        grade9++;
      } else if (data.schoolInfo.gradeToEnroll.label!.contains("10")) {
        grade10++;
      } else if (data.schoolInfo.gradeToEnroll.label!.contains("11")) {
        grade11++;
      } else if (data.schoolInfo.gradeToEnroll.label!.contains("12")) {
        grade12++;
      }
    }

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Text(
            "Different Students in grade level",
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          PieChart(
            chartRadius: size.width * 0.2,
            baseChartColor: Colors.black,
            colorList: [
              Colors.black,
              Colors.yellow,
              Colors.red,
              Colors.orange,
              Colors.deepPurple,
              Colors.blueAccent,
            ],
            dataMap: {
              "grade7": grade7,
              "grade8": grade8,
              "grade9": grade9,
              "grade10": grade10,
              "grade11": grade11,
              "grade12": grade12,
            },
          )
        ],
      ),
    );
  }
}
