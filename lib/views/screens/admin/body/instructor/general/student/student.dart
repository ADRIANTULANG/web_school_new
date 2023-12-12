import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class AdminInstructorStudentListScreen extends StatefulWidget {
  const AdminInstructorStudentListScreen({super.key});

  @override
  State<AdminInstructorStudentListScreen> createState() =>
      _AdminInstructorStudentListScreenState();
}

class _AdminInstructorStudentListScreenState
    extends State<AdminInstructorStudentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB =
          Provider.of<StudentDB>(context, listen: false);
      studentDB.updateStudentListStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Students"),
        ),
        body: StreamWrapper<List<ApplicationInfo>>(
          stream: studentDB.studentListStream,
          child: (studentList) {
            final specify = studentList!.where((ApplicationInfo element) {
              return element.schoolInfo.gradeToEnroll.label ==
                      adminDB.generalGrade!.label &&
                  element.studentInfo.section == adminDB.generalSection!.label;
            }).toList();
            return ListView.builder(
              itemCount: specify.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.grey : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: ColorTheme.primaryRed,
                            child: Text(index.toString()),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${specify[index].personalInfo.firstName} ${specify[index].personalInfo.lastName}",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                "${specify[index].schoolInfo.gradeToEnroll.label}-${specify[index].studentInfo.section}",
                                style: theme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
