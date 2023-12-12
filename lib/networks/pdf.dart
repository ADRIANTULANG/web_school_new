import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:web_school/models/application/application.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_school/models/instructor.dart';

class PdfApi {
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> saveDocumentWeb({
    required List<ApplicationInfo> studentList,
    required Instructor instructorData,
  }) async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();

    if (Platform.isWindows) {
      final pdf = Document();
      final pdfFile = await PdfInvoiceApi.generate(studentList, instructorData);
      await pdfFile.writeAsBytes(await pdf.save());
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(
      List<ApplicationInfo> applicationInfo, Instructor instructor) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        build: (context) {
          return [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Master List",
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    "Instructor: ${instructor.firstName} ${instructor.lastName}"),
                SizedBox(height: PdfPageFormat.cm * 0.8),
                TableHelper.fromTextArray(
                  headers: [
                    "Name",
                    "Grade",
                    "Section",
                  ],
                  data: applicationInfo.map((e) {
                    return [
                      "${e.personalInfo.firstName} ${e.personalInfo.lastName}",
                      e.schoolInfo.gradeToEnroll.label!,
                      e.studentInfo.section,
                    ];
                  }).toList(),
                  border: null,
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  headerDecoration:
                      const BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignment: Alignment.topLeft,
                ),
                // ListView.builder(
                //   itemBuilder: (context, index) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(applicationInfo[index].studentInfo.name),
                //             Text(applicationInfo[index].studentInfo.section),
                //             Text(applicationInfo[index]
                //                 .schoolInfo
                //                 .gradeToEnroll
                //                 .label!),
                //           ],
                //         ),
                //         Divider(
                //           height: 5.0,
                //         ),
                //       ],
                //     );
                //   },
                //   itemCount: applicationInfo.length,
                // ),
              ],
            ),
          ];
        },
      ),
    );

    return PdfApi.saveDocument(name: "my_invoice.pdf", pdf: pdf);
  }
}
