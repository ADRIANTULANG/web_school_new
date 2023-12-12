import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/student_table.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/student.dart';

@RoutePage()
class AdminStudentsListScreen extends StatefulWidget {
  AdminStudentsListScreen({
    required this.studentList,
    super.key,
  });

  final List<ApplicationInfo> studentList;

  @override
  State<AdminStudentsListScreen> createState() => _AdminStudentsListScreenState(
      masterList: studentList, studList: studentList);
}

class _AdminStudentsListScreenState extends State<AdminStudentsListScreen> {
  _AdminStudentsListScreenState({
    required this.masterList,
    required this.studList,
  });

  List<ApplicationInfo> masterList;
  List<ApplicationInfo> studList;

  searchFunctions({required String keyword}) async {
    List<ApplicationInfo> tempList = <ApplicationInfo>[];
    for (var i = 0; i < widget.studentList.length; i++) {
      print(widget.studentList[i].familyInfo.firstName);
      if (widget.studentList[i].schoolInfo.gradeToEnroll.label
              .toString()
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString()) ||
          widget.studentList[i].personalInfo.firstName
              .toString()
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString()) ||
          widget.studentList[i].personalInfo.lastName
              .toString()
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString()) ||
          widget.studentList[i].personalInfo.middleName
              .toString()
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString())) {
        tempList.add(widget.studentList[i]);
      }
    }
    setState(() {
      studList = tempList;
    });
  }

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    final ThemeData theme = Theme.of(context);

    //final DataTableSource _dataList = StudentDataList(
    //   context: context,
    //   dataList: studList,
    // );

    return ModalProgressHUD(
      inAsyncCall: studentDB.isLoading,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student List",
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width *
                      (kIsWeb ? 0.14 : 0.50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1500), () {
                        if (value.isEmpty) {
                          setState(() {
                            studList = masterList;
                          });
                        } else {
                          print(value);
                          searchFunctions(keyword: value);
                        }
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        border: InputBorder.none),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12.0),
            Divider(
              color: Colors.black,
            ),
            Container(
              width: double.infinity,

              child: PaginatedDataTable(
                columns: [
                  DataColumn(label: Text("User")),
                  DataColumn(label: Text("Username")),
                  // DataColumn(label: Text("Password")),
                  DataColumn(label: Text("Grade")),
                  DataColumn(label: Text("Delete")),
                ],
                columnSpacing: 0,
                horizontalMargin: 10,
                rowsPerPage: 10,
                source: StudentDataList(
                  context: context,
                  dataList: studList,
                ),
              ),
              // child: DataTable(
              //   dataRowMaxHeight: 60,
              //   columnSpacing: 3,
              //   headingTextStyle: theme.textTheme.bodyMedium!.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              //   columns: const [
              //     DataColumn(
              //       label: SizedBox(
              //         width: 50,
              //         child: Text("User"),
              //       ),
              //     ),
              //     DataColumn(
              //         label: SizedBox(
              //       child: Text(
              //         "User Name",
              //         softWrap: true,
              //       ),
              //     )),
              //     // DataColumn(
              //     //   label: SizedBox(
              //     //     width: 80,
              //     //     child: Text("Password"),
              //     //   ),
              //     // ),
              //     DataColumn(
              //       label: SizedBox(
              //         width: 50,
              //         child: Text("Password"),
              //       ),
              //     ),
              //     DataColumn(
              //       label: SizedBox(
              //         width: 50,
              //         child: Text("Grade"),
              //       ),
              //     ),
              //     DataColumn(
              //       label: Icon(Icons.group_remove_rounded),
              //     ),
              //   ],
              //   rows: studentList.map((e) {
              //     return DataRow(cells: [
              //       DataCell(
              //         SizedBox(
              //           width: 120,
              //           child: Row(
              //             children: [
              //               Expanded(child: Text(e.studentInfo.name)),
              //             ],
              //           ),
              //         ),
              //       ),
              //      DataCell(
              //         SizedBox(
              //           width: 120,
              //           child: Row(
              //             children: [
              //               Expanded(child: Text(e.)),
              //             ],
              //           ),
              //         ),
              //       ),
              //       // DataCell(
              //       //   GestureDetector(
              //       //     onTap: () => toggleShowPass(),
              //       //     child: Text(
              //       //       showPass
              //       //           ? e.userModel.password.replaceAll(RegExp(r"."), "*")
              //       //           : e.userModel.password,
              //       //     ),
              //       //   ),
              //       // ),
              //       DataCell(
              //         SizedBox(
              //             width: 80,
              //             child: Text("${e.schoolInfo.gradeToEnroll.label}")),
              //       ),
              //       DataCell(
              //         InkWell(
              //           borderRadius: BorderRadius.circular(24.0),
              //           onTap: () async {
              //             // await adminDB.deleteStudent(context,
              //             //   id: e.userModel.id,
              //             // );
              //           },
              //           child: const Icon(CupertinoIcons.delete),
              //         ),
              //       ),
              //     ]);
              //   }).toList(),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
