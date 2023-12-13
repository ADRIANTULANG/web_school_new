import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/option.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/models/user.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/dialogs/custom.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class AdminDB extends ChangeNotifier {
  bool isLoading = false;
  final CustomDialog customDialog = CustomDialog();

  void showHUD(bool value) {
    isLoading = value;
    notifyListeners();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? studentId;

  void updateStudentId(String? value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("studentId", value!);
    studentId = value;
    notifyListeners();
  }

  Future<void> getStudentIdLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    studentId = sp.getString("studentId");
    notifyListeners();
  }

  Stream<ApplicationInfo>? studentStream;

  Stream<ApplicationInfo> getStudent() {
    return db
        .collection("student")
        .doc(studentId)
        .snapshots()
        .map(studentFromSnapshot);
  }

  ApplicationInfo studentFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ApplicationInfo.fromJson(data);
  }

  void updateStudentStream() {
    studentStream = getStudent();
    notifyListeners();
  }

  bool schoolInfoShow = true;

  void updateSchoolInfoShow() {
    schoolInfoShow = !schoolInfoShow;
    notifyListeners();
  }

  bool personalInfoShow = true;

  void updatePersonalInfoShow() {
    personalInfoShow = !personalInfoShow;
    notifyListeners();
  }

  bool residenceInfoShow = true;

  void updateResidenceInfoShow() {
    residenceInfoShow = !residenceInfoShow;
    notifyListeners();
  }

  bool emergencyInfoShow = true;

  void updateEmergencyInfoShow() {
    emergencyInfoShow = !emergencyInfoShow;
    notifyListeners();
  }

  bool familyInfoShow = true;

  void updateFamilyInfoShow() {
    familyInfoShow = !familyInfoShow;
    notifyListeners();
  }

  /// update individual student list of
  /// subject stream
  Stream<List<Subject>>? listSubjectStream;

  Stream<List<Subject>> getListSubjectStream() {
    return db
        .collection("student")
        .doc(studentId)
        .collection("subjects")
        .snapshots()
        .map(listSubjectSnapshot);
  }

  List<Subject> listSubjectSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Subject.fromJson(data);
    }).toList();
  }

  void updateListSubjectStream() {
    listSubjectStream = getListSubjectStream();
    notifyListeners();
  }

  SelectionOption? studentSection;

  // List<SelectionOption> sectionList = [
  //   const SelectionOption(id: 0, label: "A"),
  //   const SelectionOption(id: 1, label: "B"),
  // ];

  SelectionOption? instructorSection;

  void updateInstructorSection(SelectionOption? value) {
    instructorSection = value;
    notifyListeners();
  }

  void updateStudentSection(BuildContext context,
      {SelectionOption? section, required List<Subject> subjectList}) {
    studentSection = section;
    updateSection(context, subjectList: subjectList);
    notifyListeners();
  }

  Future<void> updateSection(
    BuildContext context, {
    required List<Subject> subjectList,
  }) async {
    await db.collection("student").doc(studentId).set({
      "studentInfo": {
        "section": studentSection?.label,
      }
    }, SetOptions(merge: true)).then((value) {
      subjectList.map((subject) {
        final subjectData = Subject(
            id: subject.id,
            name: subject.name,
            grades: subject.grades,
            units: subject.units,
            // schedule: Commons.grade7SectionA[subject.id],
            schedule: []);
        db
            .collection("student")
            .doc(studentId)
            .collection("subjects")
            .doc(subject.id.toString())
            .set(subjectData.toJson(), SetOptions(merge: true));
      }).toList();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added successfully!")),
      );
      context.popRoute();
    });
  }

  static GlobalKey<FormState> addInstructorFormKey = GlobalKey();

  static TextEditingController username = TextEditingController();
  static GlobalKey<FormFieldState> usernameKey = GlobalKey();

  static TextEditingController firstName = TextEditingController();
  static GlobalKey<FormFieldState> firstNameKey = GlobalKey();

  static TextEditingController lastName = TextEditingController();
  static GlobalKey<FormFieldState> lastNameKey = GlobalKey();

  final List<SelectionOption> gradeList = [
    const SelectionOption(id: "0", label: "Grade 7"),
    const SelectionOption(id: "1", label: "Grade 8"),
    const SelectionOption(id: "2", label: "Grade 9"),
    const SelectionOption(id: "3", label: "Grade 10"),
    const SelectionOption(id: "4", label: "Grade 11"),
    const SelectionOption(id: "5", label: "Grade 12"),
  ];

  SelectionOption? gradeInstructor;

  void updateGradeInstructor(SelectionOption? value) {
    gradeInstructor = value;
    subjectOption = [];
    notifyListeners();
  }

  Future<void> addInstructor(
    BuildContext context,
    List subjectsSelected,
    Map selectedGrade,
    Map selectedSection,
    Map selectedStrandMap,
  ) async {
    var res = await FirebaseFirestore.instance
        .collection('instructor')
        .where('username', isEqualTo: "${username.text}@my.sjaiss.edu.ph")
        .get();
    if (res.docs.isEmpty) {
      final String id = Uuid().v1();

      print("add new instructor");
      var userdata = {
        "controlNumber": "${username.text}@my.sjaiss.edu.ph",
        "type": "instructor",
        "id": id,
        "password": "123456",
      };

      for (var i = 0; i < subjectsSelected.length; i++) {
        (subjectsSelected[i] as Map).remove('level');
        (subjectsSelected[i] as Map).remove('isActive');
        (subjectsSelected[i] as Map).remove('strand');
        (subjectsSelected[i] as Map).remove('strand_id');
        (subjectsSelected[i] as Map).remove('semester');
        (subjectsSelected[i] as Map).remove('semester_id');
      }
      var data = {
        "createdAt": Timestamp.now(),
        "firstName": firstName.text,
        "grade": selectedGrade,
        "lastName": lastName.text,
        "section": selectedSection,
        "strand": selectedStrandMap.isEmpty ? null : selectedStrandMap,
        "subject": subjectsSelected,
        "userModel": userdata,
        "username": "${username.text}@my.sjaiss.edu.ph",
      };

      db.collection("instructor").doc(id).set(data).then((value) {
        db.collection("user").doc(id).set(userdata);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added successfully!"),
          ),
        );
        context.popRoute();
        clearInstructorForm();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Account already exist!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> editNewInstructor(
      BuildContext context,
      List subjectsSelected,
      Map selectedGrade,
      Map selectedSection,
      Map selectedStrandMap,
      String instructorID) async {
    final String id = Uuid().v1();

    print("add new instructor");

    for (var i = 0; i < subjectsSelected.length; i++) {
      (subjectsSelected[i] as Map).remove('level');
      (subjectsSelected[i] as Map).remove('isActive');
      (subjectsSelected[i] as Map).remove('strand');
      (subjectsSelected[i] as Map).remove('strand_id');
      (subjectsSelected[i] as Map).remove('semester');
      (subjectsSelected[i] as Map).remove('semester_id');
    }
    var data = {
      "firstName": firstName.text,
      "grade": selectedGrade,
      "lastName": lastName.text,
      "section": selectedSection,
      "strand": selectedStrandMap.isEmpty ? null : selectedStrandMap,
      "subject": subjectsSelected,
    };

    db.collection("instructor").doc(instructorId).update(data).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Edited successfully!"),
        ),
      );
      context.popRoute();
      clearInstructorForm();
    });
  }

  Future<void> editInstructor(BuildContext context, String id) async {
    try {
      final DateTime now = DateTime.now();

      final UserModel userModel = UserModel(
        controlNumber: "${username.text}@my.sjaiss.edu.ph",
        type: "instructor",
        id: id,
        password: "123456",
      );

      final Instructor instructor = Instructor(
        userModel: userModel,
        username: "${username.text}@my.sjaiss.edu.ph",
        firstName: firstName.text,
        lastName: lastName.text,
        grade: gradeInstructor,
        section: instructorSection,
        strand: strandInstructorOption,
        subject: subjectOption,
        createdAt: Timestamp.fromDate(now),
      );

      db
          .collection("instructor")
          .doc(instructorId)
          .set(instructor.toJson(), SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Save successfully!"),
        ),
      );
      clearInstructorForm();
      context.popRoute();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error!"),
        ),
      );
      clearInstructorForm();
    }
  }

  bool get validateAddInstructor {
    if (firstName.text.isNotEmpty &&
        lastName.text.isNotEmpty &&
        username.text.isNotEmpty &&
        instructorSection != null) {
      if (gradeInstructor?.id == "4" || gradeInstructor?.id == "5") {
        return strandInstructorOption != null && subjectOption.isNotEmpty;
      } else {
        return subjectOption.isNotEmpty;
      }
    } else {
      return false;
    }
  }

  void clearInstructorForm() {
    firstName.clear();
    lastName.clear();
    username.clear();
    instructorSection = null;
    gradeInstructor = null;
    strandInstructorOption = null;
    subjectOption = [];
    notifyListeners();
  }

  Stream<List<Instructor>>? instructorListStream;

  Stream<List<Instructor>> getInstructorList() {
    return db
        .collection("instructor")
        .snapshots()
        .map(instructorListFromSnapshot);
  }

  List<Instructor> instructorListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      return Instructor.fromJson(data.data() as Map<String, dynamic>);
    }).toList();
  }

  void updateInstructorListStream() {
    instructorListStream = getInstructorList();
    notifyListeners();
  }

  String? instructorId;

  void updateInstructorId(String? value) async {
    instructorId = value;
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("instructorId", value!);
    notifyListeners();
  }

  Future<void> getInstructorIdLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    instructorId = sp.getString("instructorId");
    notifyListeners();
  }

  Future<void> deleteInstructor(BuildContext context, String id) async {
    CustomDialog().showAgree(
      context,
      onTap: () {
        debugPrint("Deleting: $id");
        db.collection("instructor").doc(id).delete().then((value) {
          db.collection("user").doc(id).delete();

          context.popRoute();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Deleted successfully!"),
          ));
        });
      },
      message: "Are you sure you want to delete?",
    );
  }

  Future<void> deleteStudent(BuildContext context, String studentId) async {
    CustomDialog().showAgree(
      context,
      onTap: () {
        debugPrint("Deleting: $studentId");
        db.collection("student").doc(studentId).delete().then((value) {
          db.collection("user").doc(studentId).delete();

          context.popRoute();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Deleted successfully!"),
          ));
        });
      },
      message: "Are you sure you want to delete?",
    );
  }

  SelectionOption? generalYear;

  final List<SelectionOption> generalYearList = [
    const SelectionOption(id: "0", label: "Junior High School"),
    const SelectionOption(id: "1", label: "Senior High School"),
  ];

  bool get juniorYear {
    return generalYear!.id == 0;
  }

  void updateGeneralYear(SelectionOption? value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("generalYear", jsonEncode(value!.toJson()));
    generalYear = value;
    notifyListeners();
  }

  void updateGeneralYearLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final data = sp.getString("generalYear");
    generalYear ??= SelectionOption.fromJson(jsonDecode(data!));
    notifyListeners();
  }

  SelectionOption? generalGrade;

  final List<SelectionOption> generalJuniorList = [
    const SelectionOption(id: "0", label: "Grade 7"),
    const SelectionOption(id: "1", label: "Grade 8"),
    const SelectionOption(id: "2", label: "Grade 9"),
    const SelectionOption(id: "3", label: "Grade 10"),
  ];

  final List<SelectionOption> generalSeniorList = [
    const SelectionOption(id: "0", label: "Grade 11"),
    const SelectionOption(id: "1", label: "Grade 12"),
  ];

  void updateGeneralGrade(SelectionOption? value) {
    generalGrade = value;
    notifyListeners();
  }

  SelectionOption? generalSection;

  void updateGeneralSection(SelectionOption? value) {
    generalSection = value;
    notifyListeners();
  }

  void updateState() {
    notifyListeners();
  }

  Stream<Instructor>? instructorStream;

  Stream<Instructor> getInstructor() {
    return db
        .collection("instructor")
        .doc(instructorId)
        .snapshots()
        .map(instructorFromSnapshot);
  }

  Instructor instructorFromSnapshot(DocumentSnapshot snapshot) {
    return Instructor.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  void updateInstructorStream() {
    instructorStream = getInstructor();
    notifyListeners();
  }

  // List<SelectionOption> strandInstructorList = [
  //   SelectionOption(id: 0, label: "GAS"),
  //   SelectionOption(id: 1, label: "STEM"),
  //   SelectionOption(id: 2, label: "HUMMS"),
  // ];

  SelectionOption? strandInstructorOption;

  void updateStrandInstructorOption(value) {
    strandInstructorOption = value;
    notifyListeners();
  }

  SelectionOption? semesterInstructorOption;

  void updateSemesterInstructorOption(value) {
    semesterInstructorOption = value;
    notifyListeners();
  }

  Future<List> getSubjectInstructor(
      {required String semesterID,
      required String level,
      required String strand_id}) async {
    log("semester id $semesterID");
    log("level  $level");
    log(" strand id $strand_id");

    var res = await FirebaseFirestore.instance
        .collection('subjects')
        .where('level', isEqualTo: level)
        .where('semester_id', isEqualTo: semesterID)
        .where('strand_id', isEqualTo: strand_id)
        .get();
    var subjecs = res.docs;
    List tempSub = [];
    for (var i = 0; i < subjecs.length; i++) {
      Map mapData = subjecs[i].data();

      tempSub.add(mapData);
    }
    return tempSub;
  }

  // List<Subject> get getSubjectInstructor {
  //   if (gradeInstructor?.id == 0 ||
  //       gradeInstructor?.id == 1 ||
  //       gradeInstructor?.id == 2 ||
  //       gradeInstructor?.id == 3) {
  //     return Commons.juniorSubject;
  //   } else {
  //     if (strandInstructorOption?.id == 0) {
  //       if (semesterInstructorOption?.id == 0) {
  //         return Commons.stemFirstSubjectList;
  //       } else {
  //         return Commons.stemSecondSubjectList;
  //       }
  //     } else if (strandInstructorOption?.id == 1) {
  //       if (semesterInstructorOption?.id == 0) {
  //         return Commons.gasFirstSubjectList;
  //       } else {
  //         return Commons.gasSecondSubjectList;
  //       }
  //     } else {
  //       if (semesterInstructorOption?.id == 0) {
  //         return Commons.hummsFirstSubjectList;
  //       } else {
  //         return Commons.hummsSecondSubjectList;
  //       }
  //     }
  //   }
  // }

  List<Subject> subjectOption = [];

  void updateSubjectOption(Subject value) {
    if (!subjectOption.contains(value)) {
      subjectOption.add(value);
    } else {
      subjectOption.remove(value);
    }
    notifyListeners();
  }

  Future<List<Subject>> getStudentSectionSubjects(
      ApplicationInfo applicationInfo) async {
    final grade = applicationInfo.schoolInfo.gradeToEnroll;
    final strand = applicationInfo.schoolInfo.strand;
    String collection = '';
    if (grade.label!.contains("7") ||
        grade.label!.contains("8") ||
        grade.label!.contains("9") ||
        grade.label!.contains("10")) {
      collection = 'juniorSubject';
      // return Commons.juniorSubject;
    } else if (grade.label!.contains("11")) {
      if (strand?.id == 0) {
        collection = 'gasFirstSubjectList';

        // return Commons.gasFirstSubjectList;
      } else if (strand?.id == 1) {
        collection = 'stemFirstSubjectList';

        //   return Commons.stemFirstSubjectList;
      } else {
        collection = 'hummsFirstSubjectList';

        //   return Commons.hummsFirstSubjectList;
      }
    } else {
      if (strand?.id == 0) {
        collection = 'gasSecondSubjectList';

        //   return Commons.gasSecondSubjectList;
      } else if (strand?.id == 1) {
        collection = 'stemSecondSubjectList';

        //   return Commons.stemSecondSubjectList;
      } else {
        collection = 'hummsSecondSubjectList';

        //  return Commons.hummsSecondSubjectList;
      }
    }
    var res = await FirebaseFirestore.instance.collection(collection).get();
    var subjecs = res.docs;
    List<Subject> tempSub = <Subject>[];
    for (var i = 0; i < subjecs.length; i++) {
      List<Grade> grades = <Grade>[];
      for (var x = 0; x < subjecs[i]['grades'].length; x++) {
        grades.add(Grade(
            title: subjecs[i]['grades'][x]['title'],
            grade: double.parse(subjecs[i]['grades'][x]['grade'].toString())));
      }
      tempSub.add(Subject(
          name: subjecs[i]['name'],
          grades: grades,
          units: subjecs[i]['units'],
          id: subjecs[i]['id']));
    }
    return tempSub;
  }

  showDialogSelectSection(
      {required BuildContext context, required ApplicationInfo appInfo}) async {
    var res = await FirebaseFirestore.instance.collection('sectionList').get();
    var strands = res.docs;
    List<SelectionOption> sectionList = <SelectionOption>[];
    for (var i = 0; i < strands.length; i++) {
      sectionList.add(
          SelectionOption(id: strands[i]['id'], label: strands[i]['label']));
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Assign Section",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.40,
              child: ListView.builder(
                itemCount: sectionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ListTile(
                      onTap: () async {
                        updateStudentSection(
                          context,
                          subjectList: await getStudentSectionSubjects(appInfo),
                          section: sectionList[index],
                        );
                      },
                      tileColor: Colors.lightBlue[100],
                      title: Text(sectionList[index].label!),
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  int indexDashboard = 0;

  void updateIndexDashboard(int value) {
    indexDashboard = value;
    notifyListeners();
  }

  double gwa = 0.0;

  double updateGWA(Subject subject) {
    double? total = subject.grades
        .map((e) => e.grade)
        .reduce((value, element) => value! + element!);

    return gwa = (total! / 4);
  }

  Future<void> generateJuniorPdf({
    required ApplicationInfo studentData,
    required List<Subject> subjects,
  }) async {
    final pdf = pw.Document();

    final Uint8List headerImage =
        (await rootBundle.load(PngImages.background)).buffer.asUint8List();

    final firstName = studentData.personalInfo.firstName;
    final lastName = studentData.personalInfo.lastName;
    final middleInitial = studentData.personalInfo.middleName[0].toUpperCase();

    final schoolName = studentData.schoolInfo.nameOfSchool;
    final grade = studentData.schoolInfo.gradeToEnroll.label;
    final section = studentData.studentInfo.section;
    final schoolYear = studentData.schoolInfo.schoolYear.label;

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final pw.ThemeData theme = pw.Theme.of(context);

          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(children: [
                  pw.Container(
                    height: 50,
                    width: 50,
                    child: pw.Image(
                      pw.MemoryImage(headerImage),
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                  pw.SizedBox(width: 4.0),
                  pw.Text("St. Jude Agro Industrial \nSecondary School",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      )),
                ]),
                pw.Divider(),
                pw.SizedBox(height: 24.0),
                pw.Text("Generated Report"),
                pw.Text(
                  "$firstName, $lastName $middleInitial",
                  style: theme.header0,
                ),
                pw.Text("School: $schoolName"),
                pw.Text("Grade: $grade"),
                pw.Text("School: $schoolName"),
                pw.Text("Section: $section"),
                pw.Text("School Year: $schoolYear"),
                pw.SizedBox(height: 24.0),
                pw.Table(border: pw.TableBorder.all(), children: [
                  // Header row
                  pw.TableRow(children: [
                    pw.Center(child: pw.Text("Subjects")),
                    pw.Center(child: pw.Text("1")),
                    pw.Center(child: pw.Text("2")),
                    pw.Center(child: pw.Text("3")),
                    pw.Center(child: pw.Text("4")),
                    pw.Center(child: pw.Text("Final")),
                    pw.Center(child: pw.Text("Units")),
                    pw.Center(child: pw.Text("Passed or Failed")),
                  ]),
                  // Data rows
                  for (var subject in subjects)
                    pw.TableRow(children: [
                      pw.Center(child: pw.Text(subject.name)),
                      pw.Center(
                          child: pw.Text(
                              subject.grades[0].grade!.toStringAsFixed(2))),
                      pw.Center(
                          child: pw.Text(
                              subject.grades[1].grade!.toStringAsFixed(2))),
                      pw.Center(
                          child: pw.Text(
                              subject.grades[2].grade!.toStringAsFixed(2))),
                      pw.Center(
                          child: pw.Text(
                              subject.grades[3].grade!.toStringAsFixed(2))),
                      pw.Center(child: pw.Text("${updateGWA(subject)}")),
                      pw.Center(child: pw.Text(subject.units.toString())),
                      pw.Center(
                        child: pw.Text(
                            "${gwa != 0 ? gwa >= 75 ? "PASSED" : "FAILED" : "--"}"),
                      ),
                    ]),
                ]),
              ]);
        }));

    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);

    if (kIsWeb) {
      html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
        ..setAttribute(
            "download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
        ..click();
    } else {
      // Get the directory for storing files
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/generated_pdf.pdf';

      // Write the PDF to a file
      File file = File(filePath);
      await file.writeAsBytes(savedFile);

      // Print the file path for verification
      print('PDF saved at: $filePath');
    }
  }

  void initEditInstructor(Instructor instructorData) {
    firstName.text = instructorData.firstName;
    AdminDB.lastName.text = instructorData.lastName;
    AdminDB.username.text = instructorData.username
        .substring(0, instructorData.username.indexOf("@"));

    instructorSection = instructorData.section;
    gradeInstructor = instructorData.grade;
    strandInstructorOption = instructorData.strand;
    subjectOption = instructorData.subject!;

    notifyListeners();
  }
}
