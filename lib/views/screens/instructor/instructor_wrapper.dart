import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/networks/instructor.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/screens/instructor/instructor_home.dart';
// import 'package:web_school/views/screens/instructor/navigation_bar/navigation_bar.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class WrapperInstructorScreen extends StatefulWidget {
  const WrapperInstructorScreen({
    super.key,
  });

  @override
  State<WrapperInstructorScreen> createState() =>
      _WrapperInstructorScreenState();
}

class _WrapperInstructorScreenState extends State<WrapperInstructorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB =
          Provider.of<StudentDB>(context, listen: false);
      studentDB.updateStudentListStream();

      final InstructorDB instructorDB =
          Provider.of<InstructorDB>(context, listen: false);
      final Auth auth = Provider.of<Auth>(context, listen: false);
      instructorDB.updateInstructorStream(auth.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    final InstructorDB instructorDB = Provider.of<InstructorDB>(context);

    return Scaffold(
      body: SafeArea(
        child: StreamWrapper<Instructor>(
            stream: instructorDB.instructorStream,
            child: (instructor) {
              return StreamWrapper<List<ApplicationInfo>>(
                  stream: studentDB.studentListStream,
                  child: (studentList) {
                    return InstructorHomeScreen(
                      studentList: studentList!,
                      instructor: instructor!,
                    );
                  });
            }),
      ),
    );
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       automaticallyImplyLeading: false,
    //       title: const Text("My Students"),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             auth.logout(context);
    //           },
    //           child: Text(
    //             "Logout",
    //             style: theme.textTheme.bodyMedium!.copyWith(
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(24.0),
    //       child: StreamWrapper<Instructor>(
    //           stream: instructorDB.instructorStream,
    //           child: (instructorData) {
    //             return StreamWrapper<List<ApplicationInfo>>(
    //                 stream: studentDB.studentListStream,
    //                 child: (studentList) {
    //                   final specify =
    //                       studentList!.where((ApplicationInfo element) {
    //                     return element.schoolInfo.gradeToEnroll.label ==
    //                             instructorData!.grade!.label &&
    //                         element.studentInfo.section ==
    //                             instructorData.section!.label;
    //                   }).toList();
    //                   return Column(
    //                     children: [
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text(
    //                             "Welcome, ${instructorData!.firstName} ${instructorData.lastName}",
    //                             style: theme.textTheme.bodyLarge!.copyWith(
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                           InkWell(
    //                             onTap: () async {
    //                               if (!kIsWeb) {
    //                                 final pdfFile =
    //                                     await PdfInvoiceApi.generate(
    //                                         studentList, instructorData);
    //
    //                                 PdfApi.openFile(pdfFile);
    //                               } else {
    //                                 await PdfApi.saveDocumentWeb(
    //                                   studentList: studentList,
    //                                   instructorData: instructorData,
    //                                 );
    //
    //                                 // final rawData = await pdfFile.readAsBytes();
    //                                 // final content = base64Encode(rawData);
    //                                 // AnchorElement(
    //                                 //     href:
    //                                 //         "data:application/octet-stream;charset=utf-16le;base64,$content")
    //                                 //   ..setAttribute("download", "file.txt")
    //                                 //   ..click();
    //                               }
    //                             },
    //                             child: const Text(
    //                               "Download all",
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       ListView.builder(
    //                         shrinkWrap: true,
    //                         physics: const NeverScrollableScrollPhysics(),
    //                         itemCount: specify.length,
    //                         itemBuilder: (context, index) {
    //                           return InkWell(
    //                             onTap: () {
    //                               instructorDB.updateStudentId(
    //                                   studentList[index].userModel.id);
    //                               context.pushRoute(
    //                                 InstructorGradeRoute(
    //                                   isJunior: instructorData.grade!.label!
    //                                           .contains("7") ||
    //                                       instructorData.grade!.label!
    //                                           .contains("8") ||
    //                                       instructorData.grade!.label!
    //                                           .contains("9") ||
    //                                       instructorData.grade!.label!
    //                                           .contains("10"),
    //                                 ),
    //                               );
    //                             },
    //                             child: Container(
    //                               margin:
    //                                   const EdgeInsets.symmetric(vertical: 5.0),
    //                               padding: const EdgeInsets.symmetric(
    //                                 horizontal: 24.0,
    //                                 vertical: 12.0,
    //                               ),
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.black,
    //                                 ),
    //                                 borderRadius: BorderRadius.circular(12.0),
    //                               ),
    //                               child: Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   Column(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.start,
    //                                     children: [
    //                                       Text(
    //                                         "${specify[index].personalInfo.firstName} ${specify[index].personalInfo.lastName}",
    //                                         style: theme.textTheme.bodyLarge!
    //                                             .copyWith(
    //                                           fontWeight: FontWeight.bold,
    //                                         ),
    //                                       ),
    //                                       Text(
    //                                         "${specify[index].schoolInfo.gradeToEnroll.label}-${specify[index].studentInfo.section}",
    //                                       )
    //                                     ],
    //                                   ),
    //                                   const Icon(Icons.arrow_right_alt),
    //                                 ],
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                     ],
    //                   );
    //                 });
    //           }),
    //     ),
    //   ),
    // );
  }
}
