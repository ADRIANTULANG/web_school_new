// import 'dart:convert';
// import 'dart:io';
// import 'package:universal_html/html.dart' as html;
// import 'package:pdf/widgets.dart' as pw;
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/networks/instructor.dart';
// import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/screens/instructor/navigation_bar/navigation_bar.dart';

@RoutePage()
class AdviserSeniorGradeView extends StatefulWidget {
  const AdviserSeniorGradeView(
      {required this.isJunior,
      required this.studentData,
      required this.instructor,
      super.key});
  final ApplicationInfo studentData;
  final bool isJunior;
  final Instructor instructor;
  @override
  State<AdviserSeniorGradeView> createState() => _AdviserSeniorGradeViewState();
}

class _AdviserSeniorGradeViewState extends State<AdviserSeniorGradeView> {
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
        .doc(widget.studentData.userModel.id)
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

    // for (var i = 0; i < tofilter.length; i++) {
    //   for (var x = 0; x < widget.instructor.subject!.length; x++) {
    //     if (tofilter[i].id == widget.instructor.subject![x].id) {
    //       studentSubjectList.add(tofilter[i]);
    //     }
    //   }
    // }

    setState(() {
      print(studentSubjectList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: InstructorNavigationBar(
          child: Form(
            key: InstructorDB.formKey,
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.studentData.studentInfo.name}'s grade SENIOR",
                            style: theme.textTheme.titleSmall,
                          ),
                          // ElevatedButton(
                          //     style: ButtonStyle(
                          //         backgroundColor: MaterialStatePropertyAll(
                          //             const Color.fromARGB(255, 139, 14, 5))),
                          //     onPressed: () {
                          //       // createPdf(instructor: widget.instructor);
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text("Download Grades"),
                          //     ))
                        ],
                      ),
                      const SizedBox(height: 24.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: studentSubjectList[index]
                                              .grades
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int gindex) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  // showAddGrade(
                                                  //     title: studentSubjectList[
                                                  //             index]
                                                  //         .grades[gindex]
                                                  //         .title!,
                                                  //     gradelist:
                                                  //         studentSubjectList[
                                                  //                 index]
                                                  //             .grades,
                                                  //     subjectID:
                                                  //         studentSubjectList[
                                                  //                 index]
                                                  //             .id
                                                  //             .toString());
                                                },
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
                                                trailing: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.white,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  // showAddGrade(
  //     {required String subjectID,
  //     required List<Grade> gradelist,
  //     required String title}) async {
  //   List<TextEditingController> writtenWorksinputControllers =
  //       List<TextEditingController>.generate(
  //     10,
  //     (index) => TextEditingController(text: "10"),
  //   );
  //   List<TextEditingController> writtenWorkshighestScoreControllers =
  //       List<TextEditingController>.generate(
  //     10,
  //     (index) => TextEditingController(text: "10"),
  //   );
  //   List<TextEditingController> performanceinputControllers =
  //       List<TextEditingController>.generate(
  //     10,
  //     (index) => TextEditingController(text: "10"),
  //   );
  //   List<TextEditingController> performancehighestScoreControllers =
  //       List<TextEditingController>.generate(
  //     10,
  //     (index) => TextEditingController(text: "10"),
  //   );
  //   TextEditingController quarterlyAssestmentInput =
  //       TextEditingController(text: "25");
  //   TextEditingController quarterlyAssestmentHighestScore =
  //       TextEditingController(text: "30");

  //   calculateGrades() async {
  //     double writtentotalscore = 0.0;
  //     double writtentotalhighestscore = 0.0;
  //     double performancetotalscore = 0.0;
  //     double performancehighestscore = 0.0;

  //     for (var i = 0; i < writtenWorksinputControllers.length; i++) {
  //       writtentotalscore = writtentotalscore +
  //           double.parse(writtenWorksinputControllers[i].text);
  //       writtentotalhighestscore = writtentotalhighestscore +
  //           double.parse(writtenWorkshighestScoreControllers[i].text);
  //     }

  //     for (var i = 0; i < performanceinputControllers.length; i++) {
  //       performancetotalscore = performancetotalscore +
  //           double.parse(performanceinputControllers[i].text);
  //       performancehighestscore = performancehighestscore +
  //           double.parse(performancehighestScoreControllers[i].text);
  //     }

  //     double wp = (writtentotalscore / writtentotalhighestscore) * 0.40;
  //     double pp = (performancetotalscore / performancehighestscore) * .40;
  //     double qp = (double.parse(quarterlyAssestmentInput.text) /
  //             double.parse(quarterlyAssestmentHighestScore.text)) *
  //         .20;

  //     print(wp);
  //     print(pp);
  //     print(qp);

  //     double fp = (wp + pp + qp) * 100;
  //     List newdata = [];

  //     for (var z = 0; z < gradelist.length; z++) {
  //       if (gradelist[z].title == title) {
  //         newdata.add({
  //           "grade": double.parse(fp.toStringAsFixed(1)),
  //           "title": gradelist[z].title
  //         });
  //       } else {
  //         newdata
  //             .add({"grade": gradelist[z].grade, "title": gradelist[z].title});
  //       }
  //     }

  //     print(fp.toStringAsFixed(1));
  //     await FirebaseFirestore.instance
  //         .collection("student")
  //         .doc(widget.studentData.userModel.id)
  //         .collection("subjects")
  //         .doc(subjectID)
  //         .update({"grades": newdata});
  //     getStudentSubject();
  //     Navigator.pop(context);
  //   }

  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: SizedBox(
  //             height: MediaQuery.of(context).size.height * 0.80,
  //             width: MediaQuery.of(context).size.width * 0.40,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Written Works",
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.03,
  //                             child: Text(
  //                               "Inputs",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             )),
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Expanded(
  //                         child: SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.03,
  //                             child: Text(
  //                               "Scores",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.01,
  //                   ),
  //                   for (var i = 0;
  //                       i < writtenWorksinputControllers.length;
  //                       i++) ...[
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                         top: MediaQuery.of(context).size.height * 0.01,
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: SizedBox(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.07,
  //                                 child: TextField(
  //                                   inputFormatters: [
  //                                     FilteringTextInputFormatter.digitsOnly
  //                                   ],
  //                                   keyboardType: TextInputType.number,
  //                                   controller: writtenWorksinputControllers[i],
  //                                   decoration: InputDecoration(
  //                                       hintText: "Input ${(i + 1)}",
  //                                       hintStyle: TextStyle(
  //                                         fontSize: 15,
  //                                       )),
  //                                 )),
  //                           ),
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width * 0.02,
  //                           ),
  //                           Expanded(
  //                             child: SizedBox(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.07,
  //                                 child: TextField(
  //                                   inputFormatters: [
  //                                     FilteringTextInputFormatter.digitsOnly
  //                                   ],
  //                                   keyboardType: TextInputType.number,
  //                                   controller:
  //                                       writtenWorkshighestScoreControllers[i],
  //                                   decoration: InputDecoration(
  //                                       hintStyle: TextStyle(
  //                                         fontSize: 15,
  //                                       ),
  //                                       hintText: "Highest score ${(i + 1)}"),
  //                                 )),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                   ),
  //                   Text(
  //                     "Performance Task",
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.03,
  //                             child: Text(
  //                               "Inputs",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             )),
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Expanded(
  //                         child: SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.03,
  //                             child: Text(
  //                               "Scores",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.01,
  //                   ),
  //                   for (var i = 0;
  //                       i < performanceinputControllers.length;
  //                       i++) ...[
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                         top: MediaQuery.of(context).size.height * 0.01,
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: SizedBox(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.07,
  //                                 child: TextField(
  //                                   inputFormatters: [
  //                                     FilteringTextInputFormatter.digitsOnly
  //                                   ],
  //                                   keyboardType: TextInputType.number,
  //                                   controller: performanceinputControllers[i],
  //                                   decoration: InputDecoration(
  //                                       hintText: "Input ${(i + 1)}",
  //                                       hintStyle: TextStyle(
  //                                         fontSize: 15,
  //                                       )),
  //                                 )),
  //                           ),
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width * 0.02,
  //                           ),
  //                           Expanded(
  //                             child: SizedBox(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.07,
  //                                 child: TextField(
  //                                   inputFormatters: [
  //                                     FilteringTextInputFormatter.digitsOnly
  //                                   ],
  //                                   keyboardType: TextInputType.number,
  //                                   controller:
  //                                       performancehighestScoreControllers[i],
  //                                   decoration: InputDecoration(
  //                                       hintStyle: TextStyle(
  //                                         fontSize: 15,
  //                                       ),
  //                                       hintText: "Highest score ${(i + 1)}"),
  //                                 )),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                   ),
  //                   Text(
  //                     "Quarterly Assesment",
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.03,
  //                             child: Text(
  //                               "Inputs",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             )),
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Expanded(
  //                         child: SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.03,
  //                             child: Text(
  //                               "Scores",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.01,
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                       top: MediaQuery.of(context).size.height * 0.01,
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: SizedBox(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 0.07,
  //                               child: TextField(
  //                                 inputFormatters: [
  //                                   FilteringTextInputFormatter.digitsOnly
  //                                 ],
  //                                 keyboardType: TextInputType.number,
  //                                 controller: quarterlyAssestmentInput,
  //                                 decoration: InputDecoration(
  //                                     hintText: "Input score",
  //                                     hintStyle: TextStyle(
  //                                       fontSize: 15,
  //                                     )),
  //                               )),
  //                         ),
  //                         SizedBox(
  //                           width: MediaQuery.of(context).size.width * 0.02,
  //                         ),
  //                         Expanded(
  //                           child: SizedBox(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 0.07,
  //                               child: TextField(
  //                                 inputFormatters: [
  //                                   FilteringTextInputFormatter.digitsOnly
  //                                 ],
  //                                 keyboardType: TextInputType.number,
  //                                 controller: quarterlyAssestmentHighestScore,
  //                                 decoration: InputDecoration(
  //                                     hintStyle: TextStyle(
  //                                       fontSize: 15,
  //                                     ),
  //                                     hintText: "Highest score assesment"),
  //                               )),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.02,
  //                   ),
  //                   SizedBox(
  //                       height: MediaQuery.of(context).size.height * 0.07,
  //                       width: MediaQuery.of(context).size.width * 0.40,
  //                       child: ElevatedButton(
  //                           style: ButtonStyle(
  //                               backgroundColor: MaterialStatePropertyAll(
  //                                   const Color.fromARGB(255, 131, 17, 9))),
  //                           onPressed: () {
  //                             calculateGrades();
  //                           },
  //                           child: Text("Submit")))
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  // Future<void> createPdf({
  //   required Instructor instructor,
  // }) async {
  //   final Uint8List headerImage =
  //       (await rootBundle.load(PngImages.background)).buffer.asUint8List();

  //   final pdf = pw.Document();

  //   // sort first by last name

  //   pdf.addPage(pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (pw.Context context) {
  //         final pw.ThemeData theme = pw.Theme.of(context);

  //         return pw.Column(children: [
  //           pw.Row(children: [
  //             pw.Container(
  //               height: 50,
  //               width: 50,
  //               child: pw.Image(
  //                 pw.MemoryImage(
  //                   headerImage,
  //                 ),
  //                 fit: pw.BoxFit.cover,
  //               ),
  //             ),
  //             pw.SizedBox(width: 4.0),
  //             pw.Text("St. Jude Agro Industrial Secondary School",
  //                 style: pw.TextStyle(
  //                   fontWeight: pw.FontWeight.bold,
  //                 )),
  //           ]),
  //           pw.Divider(),
  //           pw.SizedBox(height: 24.0),
  //           pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text(
  //                   "Master List",
  //                   style: theme.header0,
  //                 ),
  //                 pw.Column(children: [
  //                   pw.Text(
  //                       "Instructor Name: ${instructor.firstName} ${instructor.lastName}"),
  //                   pw.Text(
  //                       "Student Name: ${widget.studentData.personalInfo.firstName} ${widget.studentData.personalInfo.middleName} ${widget.studentData.personalInfo.lastName}"),
  //                 ])
  //               ]),
  //           pw.Table(border: pw.TableBorder.all(), children: [
  //             // Header row
  //             pw.TableRow(children: [
  //               pw.Center(child: pw.Text("Subject")),
  //               pw.Center(child: pw.Text("First Sem")),
  //               pw.Center(child: pw.Text("Second Sem")),
  //             ]),
  //             // // Data rows
  //             pw.TableRow(children: [
  //               for (var i = 0; i < studentSubjectList.length; i++) ...[
  //                 pw.Center(child: pw.Text(studentSubjectList[i].name)),
  //                 for (var x = 0;
  //                     x < studentSubjectList[i].grades.length;
  //                     x++) ...[
  //                   pw.Center(
  //                       child: pw.Text(
  //                           studentSubjectList[i].grades[x].grade.toString())),
  //                 ]
  //               ]
  //             ]),
  //           ]),
  //         ]);
  //       }));

  //   var savedFile = await pdf.save();
  //   List<int> fileInts = List.from(savedFile);

  //   if (kIsWeb) {
  //     html.AnchorElement(
  //         href:
  //             "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
  //       ..setAttribute(
  //           "download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
  //       ..click();
  //   } else {
  //     // Get the directory for storing files
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     String filePath = '${directory.path}/generated_pdf.pdf';

  //     // Write the PDF to a file
  //     File file = File(filePath);
  //     await file.writeAsBytes(savedFile);

  //     // Print the file path for verification
  //     print('PDF saved at: $filePath');
  //   }
  // }
}
