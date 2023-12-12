import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

class StudentMobileGradeScreen extends StatefulWidget {
  const StudentMobileGradeScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentMobileGradeScreen> createState() =>
      _StudentMobileGradeScreenState();
}

class _StudentMobileGradeScreenState extends State<StudentMobileGradeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB = Provider.of<StudentDB>(context, listen: false);
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.getStudentIdLocal().then((_) {
        studentDB.updateListSubjectStream(adminDB.studentId!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    final ThemeData theme = Theme.of(context);

    final personal = widget.applicationInfo.studentInfo;

    return Scaffold(
      body: SafeArea(
        child: widget.applicationInfo.studentInfo.enrolled ? StreamWrapper<List<Subject>>(
          stream: studentDB.listSubjectStream,
          child: (subjectList) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Welcome, ${personal.name}",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24.0),

                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: subjectList!.length,
                      itemBuilder: (context, index) {

                        double gwa = 0;
                        double total = 0;

                        final overallSubject = subjectList[index].grades.length;

                        subjectList[index].grades.forEach((element) {
                          total += element.grade!;
                        });

                        gwa = total / overallSubject;


                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: ColorTheme.primaryRed.withOpacity(0.8),
                                border: Border.all(),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("${subjectList[index].name} - GWA: $gwa",
                                      style: theme.textTheme.titleSmall!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.grade,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                ),
                                child: Column(
                                  children: List.generate(subjectList[index].grades.length, (indexes) {

                                    final subjects = subjectList[index].grades;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(subjects[indexes].title!,
                                              style: theme.textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text("${subjects[indexes].grade!}",
                                            style: theme.textTheme.bodyMedium!.copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        ) : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You are currently not enrolled.",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    "Please enroll first to see your grades",
                  ),
                  const SizedBox(height: 24.0),

                ],
              ),
            ),
      ),
    );
  }
}
