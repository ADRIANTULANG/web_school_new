import 'package:auto_route/auto_route.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/instructor.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';
import 'package:web_school/views/widgets/hover/button.dart';

class InstructorStudentScreen extends StatelessWidget {
  const InstructorStudentScreen({
    required this.studentList,
    required this.instructor,
    super.key,
  });

  final List<ApplicationInfo> studentList;
  final Instructor instructor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final InstructorDB instructorDB = Provider.of<InstructorDB>(context);

    // final List<ApplicationInfo> studentGradeList = studentList.map((ApplicationInfo e) {
    //
    //   if (e.schoolInfo.gradeToEnroll.id == instructor.grade?.id
    //       && e.studentInfo.section == instructor.section?.label) {
    //     return e;
    //   }
    // }).toList();

    // final List<ApplicationInfo> studentGradeList = studentList.where((e) => e.schoolInfo.gradeToEnroll.id == instructor.grade?.id
    //     && e.studentInfo.section == instructor.section?.label).toList();
    //
    String instructorGradeID = instructor.grade!.id!;
    String instructorGradeName = instructor.grade!.label!;
    List gradeIDsJunior = [0, 1, 2, 3];
    List<ApplicationInfo> getStudentGradeList = [];
    String instructorSectionName = instructor.section!.label!;
    String instructorStrandID = instructor.strand!.id!;
    List subjectIDList = [];
    for (var i = 0; i < instructor.subject!.length; i++) {
      subjectIDList.add(instructor.subject![i].id);
    }

    print("INSTRUCTOR SECTION NAME: $instructorSectionName");
    print("INSTRUCTOR STRAND ID: $instructorStrandID");
    print("INSTRUCTOR GRADE ID $instructorGradeID");

    if (gradeIDsJunior.contains(instructorGradeID)) {
      print('JUNIOR');
      // JUNIOR
      for (var i = 0; i < studentList.length; i++) {
        if (studentList[i].studentInfo.enrolled) {
          if (instructorSectionName == studentList[i].studentInfo.section) {
            if (instructorGradeName ==
                studentList[i].schoolInfo.gradeToEnroll.label) {
              getStudentGradeList.add(studentList[i]);
            }
          }
        }
      }
    } else {
      print('SENIOR');

      // SENIOR
      for (var i = 0; i < studentList.length; i++) {
        if (studentList[i].studentInfo.enrolled) {
          if (instructorSectionName == studentList[i].studentInfo.section) {
            if (instructorGradeName ==
                studentList[i].schoolInfo.gradeToEnroll.label) {
              if (instructorStrandID == studentList[i].schoolInfo.strand!.id) {
                getStudentGradeList.add(studentList[i]);
              }
            }
          }
        }
      }
    }

    // studentList.forEach((studentData) {
    //   if (instructor.grade != null) {
    //     if (studentData.schoolInfo.gradeToEnroll.label ==
    //             instructor.grade?.label &&
    //         studentData.studentInfo.section.toLowerCase() ==
    //             instructor.section?.label?.toLowerCase() &&
    //         studentData.schoolInfo.strand?.id == instructor.strand?.id) {
    //       getStudentGradeList.add(studentData);
    //     }
    //   }
    // });

    print("==================================================");

    return SafeArea(
      child: instructor.subject == null || instructor.subject!.isEmpty
          ? Center(
              child: Text("You are currently not assigned to a class."),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Student List",
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Please select a student:",
                        style: theme.textTheme.titleSmall,
                      ),
                      PrimaryButton(
                        onPressed: () async {
                          instructorDB.createPdf(
                            studentList: getStudentGradeList,
                            instructor: instructor,
                          );
                        },
                        label: "Download all",
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: getStudentGradeList.length,
                      itemBuilder: (context, index) {
                        final isJunior = getStudentGradeList[index]
                                .schoolInfo
                                .gradeToEnroll
                                .label!
                                .contains("7") ||
                            getStudentGradeList[index]
                                .schoolInfo
                                .gradeToEnroll
                                .label!
                                .contains("8") ||
                            getStudentGradeList[index]
                                .schoolInfo
                                .gradeToEnroll
                                .label!
                                .contains("9") ||
                            getStudentGradeList[index]
                                .schoolInfo
                                .gradeToEnroll
                                .label!
                                .contains("10");

                        return kIsWeb
                            ? OnHoverButton(
                                onTap: () {
                                  adminDB.updateStudentId(
                                      getStudentGradeList[index].userModel.id);
                                  isJunior
                                      ? context.pushRoute(
                                          InstructorJuniorGradeRoute(
                                            isJunior: isJunior,
                                            studentData:
                                                getStudentGradeList[index],
                                            instructor: instructor,
                                          ),
                                        )
                                      : context
                                          .pushRoute(InstructorSeniorGradeRoute(
                                          isJunior: isJunior,
                                          instructor: instructor,
                                          studentData:
                                              getStudentGradeList[index],
                                        ));
                                },
                                builder: (isHovered) => Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${getStudentGradeList[index].studentInfo.name}",
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: isHovered
                                                        ? Colors.white
                                                        : Colors.black87),
                                          ),
                                          Text(
                                            "${getStudentGradeList[index].schoolInfo.gradeToEnroll.label}-${getStudentGradeList[index].studentInfo.section}",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: isHovered
                                                        ? Colors.white
                                                        : Colors.black87),
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.arrow_right_alt,
                                          color: isHovered
                                              ? Colors.white
                                              : Colors.black87),
                                    ],
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        const Color.fromARGB(
                                            255, 167, 21, 11))),
                                onPressed: () {
                                  adminDB.updateStudentId(
                                      getStudentGradeList[index].userModel.id);
                                  isJunior
                                      ? context.pushRoute(
                                          InstructorJuniorGradeRoute(
                                            isJunior: isJunior,
                                            studentData:
                                                getStudentGradeList[index],
                                            instructor: instructor,
                                          ),
                                        )
                                      : context
                                          .pushRoute(InstructorSeniorGradeRoute(
                                          isJunior: isJunior,
                                          instructor: instructor,
                                          studentData:
                                              getStudentGradeList[index],
                                        ));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${getStudentGradeList[index].studentInfo.name}",
                                              style: theme.textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              "${getStudentGradeList[index].schoolInfo.gradeToEnroll.label}-${getStudentGradeList[index].studentInfo.section}",
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.arrow_right_alt,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                ],
              ),
            ),
    );
  }
}
