// import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/user.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';

import '../../../models/application/application.dart';
import '../../../models/application/emergency.dart';
import '../../../models/application/family.dart';
import '../../../models/application/personal.dart';
import '../../../models/application/residence.dart';
import '../../../models/application/school.dart';
import '../../../models/application/student.dart';
import '../../../networks/router/routes.gr.dart';
import '../../widgets/hover/button.dart';

@RoutePage()
class AdviserScreen extends StatefulWidget {
  const AdviserScreen({super.key, required this.instructorDetails});
  final Instructor instructorDetails;

  @override
  State<AdviserScreen> createState() => _AdviserScreenState();
}

class _AdviserScreenState extends State<AdviserScreen> {
  List studentsList = [];
  List<ApplicationInfo> applicationInfoList = <ApplicationInfo>[];
  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  getAllStudents() async {
    try {
      var instructorDocument = FirebaseFirestore.instance
          .collection('instructor')
          .doc(widget.instructorDetails.userModel.id);

      var res = await FirebaseFirestore.instance
          .collection('student')
          .where('schoolInfo.adviser', isEqualTo: instructorDocument)
          .get();
      var students = res.docs;
      // List temp = [];
      List<ApplicationInfo> tempModeledList = <ApplicationInfo>[];
      for (var i = 0; i < students.length; i++) {
        var data = students[i].data();
        (data['schoolInfo'] as Map).remove('adviser');
        // data['createdAt'] = data['createdAt'].toDate();
        var appinfo = ApplicationInfo(
          userModel: UserModel.fromJson(data["userModel"]),
          studentInfo: StudentInfo.fromJson(data["studentInfo"]),
          schoolInfo: SchoolInfo.fromJson(data["schoolInfo"]),
          personalInfo: PersonalInfo.fromJson(data["personalInfo"]),
          emergencyInfo: EmergencyInfo.fromJson(data["emergencyInfo"]),
          residenceInfo: ResidenceInfo.fromJson(data["residenceInfo"]),
          familyInfo: FamilyInfo.fromJson(data["familyInfo"]),
          createdAt: data["createdAt"],
        );
        tempModeledList.add(appinfo);
      }
      setState(() {
        applicationInfoList = tempModeledList;
      });
      // setState(() {
      //   studentsList = temp;
      // });
    } on Exception catch (_) {
      print(_.toString());
    }
  }

  @override
  void initState() {
    print(widget.instructorDetails.userModel.id);
    getAllStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Adviser's Student List",
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
                  // instructorDB.createPdf(
                  //   studentList: getStudentGradeList,
                  //   instructor: instructor,
                  // );
                },
                label: "Download all",
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          ListView.builder(
              shrinkWrap: true,
              itemCount: applicationInfoList.length,
              itemBuilder: (context, index) {
                final isJunior = applicationInfoList[index]
                        .schoolInfo
                        .gradeToEnroll
                        .label!
                        .contains("7") ||
                    applicationInfoList[index]
                        .schoolInfo
                        .gradeToEnroll
                        .label!
                        .contains("8") ||
                    applicationInfoList[index]
                        .schoolInfo
                        .gradeToEnroll
                        .label!
                        .contains("9") ||
                    applicationInfoList[index]
                        .schoolInfo
                        .gradeToEnroll
                        .label!
                        .contains("10");

                return kIsWeb
                    ? OnHoverButton(
                        onTap: () {
                          // adminDB.updateStudentId(
                          //     getStudentGradeList[index].userModel.id);
                          isJunior
                              ? context.pushRoute(
                                  AdviserJuniorGradeView(
                                    isJunior: isJunior,
                                    studentData: applicationInfoList[index],
                                    instructor: widget.instructorDetails,
                                  ),
                                )
                              : context.pushRoute(AdviserSeniorGradeView(
                                  isJunior: isJunior,
                                  instructor: widget.instructorDetails,
                                  studentData: applicationInfoList[index],
                                ));
                        },
                        builder: (isHovered) => Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${applicationInfoList[index].studentInfo.name}",
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isHovered
                                            ? Colors.white
                                            : Colors.black87),
                                  ),
                                  Text(
                                    "${applicationInfoList[index].schoolInfo.gradeToEnroll.label}-${applicationInfoList[index].studentInfo.section}",
                                    style: theme.textTheme.bodyMedium!.copyWith(
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
                                const Color.fromARGB(255, 167, 21, 11))),
                        onPressed: () {
                          isJunior
                              ? context.pushRoute(
                                  AdviserJuniorGradeView(
                                    isJunior: isJunior,
                                    studentData: applicationInfoList[index],
                                    instructor: widget.instructorDetails,
                                  ),
                                )
                              : context.pushRoute(AdviserSeniorGradeView(
                                  isJunior: isJunior,
                                  instructor: widget.instructorDetails,
                                  studentData: applicationInfoList[index],
                                ));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${applicationInfoList[index].studentInfo.name}",
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                    ),
                                    Text(
                                      "${applicationInfoList[index].schoolInfo.gradeToEnroll.label}-${applicationInfoList[index].studentInfo.section}",
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(color: Colors.white),
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
    );
  }
}
