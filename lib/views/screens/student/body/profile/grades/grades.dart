import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/student/subject.dart';
// import 'package:web_school/networks/admin.dart';
// import 'package:web_school/networks/student.dart';
// import 'package:web_school/views/screens/student/body/profile/grades/junior_grade.dart';
import 'package:web_school/views/screens/student/body/profile/grades/no_grades.dart';
// import 'package:web_school/views/screens/student/body/profile/grades/senior_grade.dart';
// import 'package:web_school/views/widgets/body/wrapper/stream.dart';

class StudentWebGradesScreen extends StatefulWidget {
  const StudentWebGradesScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentWebGradesScreen> createState() => _StudentWebGradesScreenState();
}

class _StudentWebGradesScreenState extends State<StudentWebGradesScreen> {
  @override
  void initState() {
    super.initState();
    getStudentSubject();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final StudentDB studentDB =
    //       Provider.of<StudentDB>(context, listen: false);
    //   final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
    //   adminDB.getStudentIdLocal().then((_) {
    //     studentDB.updateListSubjectStream(adminDB.studentId!);
    //   });
    // });
  }

  List<Subject> studentSubjectList = <Subject>[];
  List<Subject> tofilter = <Subject>[];

  getStudentSubject() async {
    studentSubjectList.clear();
    var res = await FirebaseFirestore.instance
        .collection("student")
        .doc(widget.applicationInfo.userModel.id)
        .collection("subjects")
        .get();

    var subjects = res.docs;
    List<Subject> tempData = <Subject>[];
    for (var i = 0; i < subjects.length; i++) {
      List<Grade> gradesList = <Grade>[];
      for (var x = 0; x < subjects[i]['grades'].length; x++) {
        gradesList.add(Grade(
            title: subjects[i]['grades'][x]['title'],
            grade: double.parse(subjects[i]['grades'][x]['grade'].toString())));
      }
      tempData.add(Subject(
          name: subjects[i]['name'],
          grades: gradesList,
          units: subjects[i]['units'],
          id: subjects[i]['id']));
    }
    studentSubjectList = tempData;

    setState(() {
      print(studentSubjectList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final StudentDB studentDB = Provider.of<StudentDB>(context);

    return Form(
      child: widget.applicationInfo.studentInfo.enrolled
          ? Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Grades",
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: studentSubjectList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      studentSubjectList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: studentSubjectList[index]
                                            .grades
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int gindex) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            child: ListTile(
                                              tileColor: const Color.fromARGB(
                                                  255, 107, 11, 4),
                                              title: Text(
                                                studentSubjectList[index]
                                                    .grades[gindex]
                                                    .title
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                studentSubjectList[index]
                                                    .grades[gindex]
                                                    .grade
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          : NotEnrolledScreen(),
    );
  }
}
