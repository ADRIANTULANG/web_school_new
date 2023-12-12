
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/charts/custom_line.dart';

class StudentsInstructors extends StatelessWidget {
  const StudentsInstructors({
    required this.studentList,
    required this.instructorList,
    super.key,
  });

  final List<ApplicationInfo> studentList;
  final List<Instructor> instructorList;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    List<FlSpot> generateStudentSpots(List<ApplicationInfo> students) {
      // Create FlSpot values based on student data
      List<FlSpot> spots = [FlSpot(0, 0)];
      for (int i = 0; i < students.length; i++) {
        // X-value is the index (number of students with the same createdAt date)
        // Y-value is the hour of the createdAt time

        final DateTime toDateCreated = students[i].createdAt.toDate();
        spots.add(FlSpot(toDateCreated.month.toDouble(), i.toDouble()));
      }

      spots.sort((a, b) => a.x.compareTo(b.x));
      return spots;
    }

    print(generateStudentSpots(studentList));

    List<FlSpot> generateInstructorSpots(List<Instructor> instructors) {
      // Create FlSpot values based on student data
      List<FlSpot> spots = [];
      for (int i = 0; i < instructors.length; i++) {
        // X-value is the index (number of students with the same createdAt date)
        // Y-value is the hour of the createdAt time

        final DateTime toDateCreated = instructors[i].createdAt.toDate();
        spots.add(FlSpot(toDateCreated.month.toDouble(), i.toDouble()));
      }

      spots.sort((a, b) => a.x.compareTo(b.x));
      return spots;
    }

    print(generateInstructorSpots(instructorList));

    // final maxDate = studentList.map((e) => e.createdAt.toDate().day.toDouble()).reduce((a, b) => max(a, b));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: ColorTheme.primaryGreen,
            border: Border.all(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${studentList.length}",
                        style: theme.textTheme.titleSmall,
                      ),
                      Text("Students",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.arrow_circle_right),
                  ),
                ],
              ),

              const SizedBox(height: 12.0),
              CustomLineChart(
                dataList: studentList,
                flSpots: generateStudentSpots(studentList),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: ColorTheme.primaryGreen,
            border: Border.all(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${instructorList.length}",
                        style: theme.textTheme.titleSmall,
                      ),
                      Text("Instructors",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                    },
                    icon: Icon(Icons.arrow_circle_right),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              CustomLineChart(
                dataList: instructorList,
                flSpots: generateInstructorSpots(instructorList),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),

        // Expanded(
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        //     color: ColorTheme.primaryYellow,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text("${instructorList.length}",
        //           style: theme.textTheme.titleSmall,
        //         ),
        //         Text("Students",
        //           style: theme.textTheme.bodyMedium!.copyWith(
        //             color: Colors.grey,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //         SizedBox(
        //           height: 100,
        //           child: LineChart(
        //             LineChartData(
        //               gridData: FlGridData(show: false),
        //               minX: 0,
        //               minY: 0,
        //               maxX: studentList.length - 1,
        //               maxY: maxDate + 2,
        //               lineBarsData: [
        //                 LineChartBarData(
        //                   spots: generateSpots(studentList),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Expanded(
        //   child: InkWell(
        //     borderRadius: BorderRadius.circular(12.0),
        //     onTap: () {
        //       context.pushRoute(const AdminStudentsRoute());
        //     },
        //     child: GreyTile(
        //       backgroundColor: Colors.black,
        //       child: Column(
        //         crossAxisAlignment:
        //         CrossAxisAlignment.stretch,
        //         children: [
        //           Text(
        //             "${studentList.length}",
        //             style: theme.textTheme.titleMedium!
        //                 .copyWith(
        //               color: Colors.white,
        //             ),
        //           ),
        //           const SizedBox(height: 4.0),
        //           Text(
        //             "Total Students",
        //             style: theme.textTheme.bodyLarge!
        //                 .copyWith(
        //               color: Colors.white,
        //             ),
        //           ),
        //           const SizedBox(height: 50.0),
        //           LinearPercentIndicator(
        //             percent: studentList.length / 100,
        //             barRadius: const Radius.circular(12),
        //             lineHeight: 12,
        //             backgroundColor: Colors.white,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 12.0),

      ],
    );
  }
}
