import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import 'package:web_school/values/strings/images.dart';

class InstructorDB extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  bool isLoading = false;

  void showHUD(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Stream<Instructor>? instructorStream;
  Stream<Instructor> getInstructor(String id) {
    try {
      return db
          .collection("instructor")
          .doc(id)
          .snapshots()
          .map(instructorFromSnapshot);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Instructor instructorFromSnapshot(DocumentSnapshot snapshot) {
    return Instructor.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  void updateInstructorStream(String id) {
    instructorStream = getInstructor(id);
    notifyListeners();
  }

  String? studentId;

  void updateStudentId(String? value) async {
    studentId = value;

    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("studentId", studentId!);
    notifyListeners();
  }

  Future<void> getStudentIdLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    studentId = sp.getString("studentId");
    notifyListeners();
  }

  String? instructorId;

  void updateInstructorId(String? value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    instructorId = value;

    sp.setString("instructorId", instructorId!);

    notifyListeners();
  }

  Future<void> getInstructorIdLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    instructorId = sp.getString("instructorId");

    notifyListeners();
  }

  Stream<List<Subject>>? subjectListStream;

  Stream<List<Subject>> getSubjectList() {
    return db
        .collection("student")
        .doc(studentId)
        .collection("subjects")
        .snapshots()
        .map(subjectListFromSnapshot);
  }

  List<Subject> subjectListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Subject.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  void updateSubjectListStream() {
    subjectListStream = getSubjectList();
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

  ApplicationInfo studentFromSnapshot(DocumentSnapshot doc) {
    return ApplicationInfo.fromJson(doc.data() as Map<String, dynamic>);
  }

  void updateStudentStream() {
    studentStream = getStudent();
    notifyListeners();
  }

  static GlobalKey<FormState> formKey = GlobalKey();

  static TextEditingController first = TextEditingController();
  static GlobalKey<FormFieldState> firstKey = GlobalKey();

  static TextEditingController second = TextEditingController();
  static GlobalKey<FormFieldState> secondKey = GlobalKey();

  static TextEditingController third = TextEditingController();
  static GlobalKey<FormFieldState> thirdKey = GlobalKey();

  static TextEditingController fourth = TextEditingController();
  static GlobalKey<FormFieldState> fourthKey = GlobalKey();

  void initGradeText({
    required String firstGrade,
    required String secondGrade,
    required String thirdGrade,
    required String fourthGrade,
  }) {
    first.text = firstGrade;
    second.text = secondGrade;
    third.text = thirdGrade;
    fourth.text = fourthGrade;
    notifyListeners();
  }

  void initSeniorGradeText({
    required String grade,
  }) {
    first.text = grade;
    notifyListeners();
  }

  String? subjectId;

  void updateSubjectId(String? value) {
    subjectId = value;
    notifyListeners();
  }

  Future<void> updateGrade(
    BuildContext context, {
    required List<Grade> currentGradeList,
    required ApplicationInfo applicationInfo,
  }) async {
    final List<Grade> object = [
      Grade(
        title: currentGradeList[0].title,
        grade: double.parse(first.text),
      ),
      Grade(
        title: currentGradeList[1].title,
        grade: double.parse(second.text),
      ),
      Grade(
        title: currentGradeList[2].title,
        grade: double.parse(third.text),
      ),
      Grade(
        title: currentGradeList[3].title,
        grade: double.parse(fourth.text),
      ),
    ];

    showHUD(true);
    try {
      await db
          .collection("student")
          .doc(applicationInfo.userModel.id)
          .collection("subjects")
          .doc(subjectId)
          .update(
        {
          "grades": FieldValue.arrayRemove(
              currentGradeList.map((e) => e.toJson()).toList()),
        },
      ).then((value) {
        db
            .collection("student")
            .doc(applicationInfo.userModel.id)
            .collection("subjects")
            .doc(subjectId)
            .update(
          {
            "grades":
                FieldValue.arrayUnion(object.map((e) => e.toJson()).toList()),
          },
        );
        showHUD(false);
        context.popRoute();
      });
    } catch (e) {
      showHUD(false);
      context.popRoute();
    }
  }

  void clearGradeForm() {
    first.clear();
    second.clear();
    third.clear();
    fourth.clear();
    notifyListeners();
  }

  bool get validateGrade {
    return first.text.isNotEmpty &&
        second.text.isNotEmpty &&
        third.text.isNotEmpty &&
        fourth.text.isNotEmpty;
  }

  int drawerIndex = 0;

  void updateDrawerIndex(int value) {
    drawerIndex = value;
    notifyListeners();
  }

  Subject? instructorSubjectFilter;

  void updateInstructorSubjectFilter(Subject? subject) {
    instructorSubjectFilter = subject;
    notifyListeners();
  }

  io.File? selectFile;
  Uint8List? selectedImageInBytes;
  String? fileName;

  Future<void> addFile(BuildContext context) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    final SharedPreferences sp = await SharedPreferences.getInstance();

    if (fileResult != null && fileResult.files.isNotEmpty) {
      // selectFile = io.File(fileResult.files.single.path!);
      fileName = fileResult.files.first.name;
      selectedImageInBytes = fileResult.files.first.bytes;

      await firebaseStorage
          .ref("instructor/$fileName")
          .putData(fileResult.files.single.bytes!);

      await firebaseStorage
          .ref("instructor/$fileName")
          .getDownloadURL()
          .then((value) async {
        print(value);

        instructorId = sp.getString("instructorId");

        db.collection("instructor").doc(instructorId).set({
          "profilePic": value,
        }, SetOptions(merge: true));
      });
    }
    notifyListeners();
  }

  Stream<String>? instructorProfileStream;

  Stream<String> getInstructorProfile() {
    return db
        .collection("instructor")
        .doc(instructorId)
        .snapshots()
        .map((event) {
      final data = event.data() as Map<String, dynamic>;
      return data["profilePic"];
    });
  }

  void updateInstructorProfileStream() {
    instructorProfileStream = getInstructorProfile();
    notifyListeners();
  }

  Future<void> createPdf({
    required List<ApplicationInfo> studentList,
    required Instructor instructor,
  }) async {
    final Uint8List headerImage =
        (await rootBundle.load(PngImages.background)).buffer.asUint8List();

    final pdf = pw.Document();

    // sort first by last name

    studentList.sort(
        (a, b) => a.personalInfo.lastName.compareTo(b.personalInfo.lastName));

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final pw.ThemeData theme = pw.Theme.of(context);

          return pw.Column(children: [
            pw.Row(children: [
              pw.Container(
                height: 50,
                width: 50,
                child: pw.Image(
                  pw.MemoryImage(
                    headerImage,
                  ),
                  fit: pw.BoxFit.cover,
                ),
              ),
              pw.SizedBox(width: 4.0),
              pw.Text("St. Jude Agro Industrial Secondary School",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  )),
            ]),
            pw.Divider(),
            pw.SizedBox(height: 24.0),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Master List",
                    style: theme.header0,
                  ),
                  pw.Text(
                      "Instructor Name: ${instructor.firstName} ${instructor.lastName}"),
                ]),
            pw.Table(border: pw.TableBorder.all(), children: [
              // Header row
              pw.TableRow(children: [
                pw.Center(child: pw.Text("Name")),
                pw.Center(child: pw.Text("LRN")),
                pw.Center(child: pw.Text("Grade")),
                pw.Center(child: pw.Text("Section")),
              ]),
              // Data rows
              for (var user in studentList)
                pw.TableRow(children: [
                  pw.Center(
                      child: pw.Text(
                          "${user.personalInfo.lastName}, ${user.personalInfo.firstName}, ${user.personalInfo.middleName[0].toUpperCase()}.")),
                  pw.Center(child: pw.Text(user.personalInfo.lrn)),
                  pw.Center(
                      child: pw.Text("${user.schoolInfo.gradeToEnroll.label}")),
                  pw.Center(child: pw.Text(user.studentInfo.section)),
                ]),
            ]),
          ]);
        }));

    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);

    // html.AnchorElement(
    //     href: "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
    //   ..setAttribute("download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
    //   ..click();

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

  Future<void> updateSeniorGrade(
    BuildContext context, {
    required String id,
    required String subjectId,
    required String grade,
  }) async {
    try {
      db
          .collection("student")
          .doc(id)
          .collection("subjects")
          .doc(subjectId)
          .set({
        "grades": [
          {
            "grade": grade,
          }
        ],
      }, SetOptions(merge: true)).then((value) {
        context.popRoute();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successful!"),
          ),
        );
      });
    } catch (e) {
      print("Error: $e");
    }
  }
}
