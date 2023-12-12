import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/views/screens/admin/body/student/profile/component/student_details.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class AdminStudentProfileScreen extends StatefulWidget {
  const AdminStudentProfileScreen({
    super.key,
  });

  @override
  State<AdminStudentProfileScreen> createState() =>
      _AdminStudentProfileScreenState();
}

class _AdminStudentProfileScreenState extends State<AdminStudentProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.getStudentIdLocal().then((value) {
        adminDB.updateStudentStream();
        adminDB.updateListSubjectStream();
      });
    });
  }

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  @override
  Widget build(BuildContext context) {
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: AdminNavigationBar(
          child: Center(
            child: StreamWrapper<ApplicationInfo>(
              stream: adminDB.studentStream,
              child: (applicationInfo) {
                return StreamWrapper<List<Subject>>(
                  stream: adminDB.listSubjectStream,
                  child: (subjectList) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${applicationInfo!.studentInfo.name} Profile",
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Divider(
                              color: Colors.black,
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            applicationInfo.studentInfo.name)),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: applicationInfo
                                                  .studentInfo.section.isEmpty
                                              ? null
                                              : () {
                                                  showAdviser(
                                                      studentDetails:
                                                          applicationInfo);
                                                },
                                          child: Text(
                                            "Adviser",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color: applicationInfo.studentInfo
                                                      .section.isEmpty
                                                  ? Colors.grey
                                                  : Colors.blue,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: applicationInfo
                                                  .studentInfo.section.isEmpty
                                              ? null
                                              : () {
                                                  context.pushRoute(
                                                    AdminScheduleStudentRoute(),
                                                  );
                                                },
                                          child: Text(
                                            "See schedule",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color: applicationInfo.studentInfo
                                                      .section.isEmpty
                                                  ? Colors.grey
                                                  : Colors.blue,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: TextButton(
                                            onPressed: () {
                                              adminDB.showDialogSelectSection(
                                                  appInfo: applicationInfo,
                                                  context: context);
                                            },
                                            child: Text(
                                              "Assign",
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: "Generate report",
                                          child: IconButton(
                                            icon: Icon(CupertinoIcons
                                                .cloud_download_fill),
                                            onPressed: () {
                                              adminDB.generateJuniorPdf(
                                                subjects: subjectList!,
                                                studentData: applicationInfo,
                                              );
                                              print("generate report");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            StudentDetails(
                              applicationInfo: applicationInfo,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  showAdviser({required ApplicationInfo studentDetails}) async {
    List instructorList = [];
    String adviserID = '';
    String adviserName = 'None';
    var resStudent = await FirebaseFirestore.instance
        .collection('student')
        .doc(studentDetails.userModel.id)
        .get();
    if (resStudent.exists) {
      var studentData = resStudent.data();
      if (studentData != null) {
        if ((studentData['schoolInfo'] as Map).containsKey('adviser')) {
          var resAdviserDetails =
              await (studentData['schoolInfo']['adviser'] as DocumentReference)
                  .get();
          if (resAdviserDetails.exists) {
            var adviserDetailsData = resAdviserDetails.data() as Map;
            adviserName = adviserDetailsData['firstName']
                    .toString()
                    .capitalize()
                    .toString() +
                " " +
                adviserDetailsData['lastName']
                    .toString()
                    .capitalize()
                    .toString();
            adviserID = adviserDetailsData['userModel']['id'];
          }
        }
      }
    }

    var resInstructor = await FirebaseFirestore.instance
        .collection('instructor')
        .where('grade.label',
            isEqualTo: studentDetails.schoolInfo.gradeToEnroll.label)
        .get();
    var instructors = resInstructor.docs;
    for (var i = 0; i < instructors.length; i++) {
      Map datamap = instructors[i].data();
      instructorList.add(datamap);
    }

    updateAdviser({required String id}) async {
      var adviserDocumentRef =
          FirebaseFirestore.instance.collection('instructor').doc(id);
      await FirebaseFirestore.instance
          .collection('student')
          .doc(studentDetails.userModel.id)
          .update({"schoolInfo.adviser": adviserDocumentRef});
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Adviser updated'),
      ));
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: SizedBox(
                // width: getWidth(80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Adviser ${studentDetails.schoolInfo.gradeToEnroll.label}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    kIsWeb
                        ? Row(
                            children: [
                              Text(
                                "Current adviser:  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                adviserName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              content: SizedBox(
                height: getHeight(80),
                width: getWidth(80),
                child: ListView.builder(
                  itemCount: instructorList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: getHeight(1),
                      ),
                      child: ListTile(
                          onTap: () {
                            updateAdviser(
                                id: instructorList[index]['userModel']['id']);
                          },
                          tileColor: const Color.fromARGB(255, 156, 18, 8),
                          hoverColor: Color.fromARGB(255, 241, 92, 92),
                          trailing: adviserID ==
                                  instructorList[index]['userModel']['id']
                              ? Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.white,
                                )
                              : SizedBox(),
                          title: Text(
                            instructorList[index]['firstName'] +
                                " " +
                                instructorList[index]['lastName'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    );
                  },
                ),
              ),
            );
          });
        });
  }
}
