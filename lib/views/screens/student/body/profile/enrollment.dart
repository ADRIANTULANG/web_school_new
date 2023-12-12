import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';
import 'package:web_school/views/widgets/buttons/checkbox.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';

@RoutePage()
class StudentWebEnrollmentScreen extends StatefulWidget {
  const StudentWebEnrollmentScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentWebEnrollmentScreen> createState() =>
      _StudentWebEnrollmentScreenState();
}

class _StudentWebEnrollmentScreenState extends State<StudentWebEnrollmentScreen> {
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

    final studentInfo = widget.applicationInfo.studentInfo;

    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: StreamWrapper<List<Subject>>(
          stream: studentDB.listSubjectStream,
          child: (subjectList) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Admission Status",
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Enrollment Status: ",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: studentDB.enrollmentStatus(studentInfo),
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: studentDB.enrollmentStatus(studentInfo).contains("not")
                                    ? Colors.red
                                    : ColorTheme.primaryBlack,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    !widget.applicationInfo.studentInfo.enrolled ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Subjects enrolled",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(studentDB.subjectEnrollList.length, (index) {
                                final subject = studentDB.subjectEnrollList[index];

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(subject.name)),
                                    IconButton(
                                      onPressed: () {
                                        studentDB.updateRemoveSubjectEnrollList(index);
                                      },
                                      icon: Icon(Icons.remove,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Subjects",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Column(
                              children: List.generate(subjectList!.length, (index) {
                                return Visibility(
                                  visible: !studentDB.subjectEnrollList.contains(subjectList[index]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(subjectList[index].name)),
                                        CustomCheckbox(
                                          value: studentDB.subjectEnrollList.contains(subjectList[index]),
                                          onChanged: (value) {
                                            studentDB.updateAddSubjectEnrollList(subjectList[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24.0),

                        PrimaryButton(
                          isEnabled: studentDB.validateEnrollment(subjectList),
                          onPressed: () {
                            studentDB.updateEnrollProfile(context, widget.applicationInfo);
                          },
                          label: "Enroll",
                        ),
                      ],
                    ) : const SizedBox()
                  ],
                ),
              ),
            );
          }),
    );
  }
}
