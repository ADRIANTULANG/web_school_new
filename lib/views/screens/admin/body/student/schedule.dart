import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/date.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class AdminScheduleStudentScreen extends StatefulWidget {
  const AdminScheduleStudentScreen({
    super.key,
  });

  @override
  State<AdminScheduleStudentScreen> createState() =>
      _AdminScheduleStudentScreenState();
}

class _AdminScheduleStudentScreenState
    extends State<AdminScheduleStudentScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB =
          Provider.of<StudentDB>(context, listen: false);
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.getStudentIdLocal().then((_) {
        studentDB.updateListSubjectStream(adminDB.studentId!);
        studentDB.updateStudentStream(adminDB.studentId!);
        getSchedule(studentID: adminDB.studentId!);
      });
    });
  }

  Map<dynamic, dynamic>? studentDetails;
  Map<dynamic, dynamic>? studentDetailsMasterList;

  getSchedule({required String studentID}) async {
    var res = await FirebaseFirestore.instance
        .collection('student')
        .doc(studentID)
        .get();
    if (res.exists) {
      studentDetails = res.data();
      studentDetailsMasterList = res.data();
    }
  }

  List<String> list = <String>[
    '',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StudentDB studentDB = Provider.of<StudentDB>(context);

    return Scaffold(
      body: SafeArea(
        child: AdminNavigationBar(
          child: StreamWrapper<ApplicationInfo>(
              stream: studentDB.studentStream,
              child: (studentInfo) {
                return StreamWrapper<List<Subject>>(
                    stream: studentDB.listSubjectStream,
                    child: (subjectList) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Student Profile",
                                    style: theme.textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width *
                                        (kIsWeb ? 0.14 : 0.50),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: DropdownButton<String>(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      value: dropdownValue,
                                      elevation: 16,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Divider(
                                color: Colors.black,
                              ),
                              const SizedBox(height: 12.0),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: subjectList!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 12.0,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: ColorTheme.primaryRed
                                          .withOpacity(0.9),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subjectList[index].name,
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var i = 0;
                                                i <
                                                    subjectList[index]
                                                        .schedule!
                                                        .length;
                                                i++) ...[
                                              //          DateTime date = schedule
                                              //     .getNextDayTime(schedule);
                                              // final String startDate =
                                              //     DateFormat("EEEE, h:mma")
                                              //         .format(date);
                                              // final String endDate =
                                              //     DateFormat("h:mma")
                                              //         .format(date.add(
                                              //   Duration(hours: 1),
                                              // ));
                                              if (DateFormat("EEEE, h:mma")
                                                  .format(subjectList[index]
                                                      .schedule![i]
                                                      .getNextDayTime(
                                                          subjectList[index]
                                                              .schedule![i]))
                                                  .toLowerCase()
                                                  .toString()
                                                  .contains(dropdownValue
                                                      .toLowerCase()
                                                      .toString())) ...[
                                                Text(
                                                  "${DateFormat("EEEE, h:mma").format(subjectList[index].schedule![i].getNextDayTime(subjectList[index].schedule![i]))} - ${DateFormat("h:mma").format(subjectList[index].schedule![i].getNextDayTime(subjectList[index].schedule![i]).add(
                                                        Duration(hours: 1),
                                                      ))}",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ]
                                            ]
                                          ],
                                          // children: subjectList[index]
                                          //     .schedule!
                                          //     .map((schedule) {
                                          //   final DateTime date = schedule
                                          //       .getNextDayTime(schedule);
                                          //   final String startDate =
                                          //       DateFormat("EEEE, h:mma")
                                          //           .format(date);
                                          //   final String endDate =
                                          //       DateFormat("h:mma")
                                          //           .format(date.add(
                                          //     Duration(hours: 1),
                                          //   ));

                                          //   return Text(
                                          //     "${startDate} - ${endDate}",
                                          //     style: theme.textTheme.bodyMedium!
                                          //         .copyWith(
                                          //       color: Colors.white,
                                          //     ),
                                          //   );
                                          // }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       border: Border.all(
                              //         color: Colors.black,
                              //       )),
                              //   child: DataTable(
                              //     dataRowMaxHeight: 150,
                              //     columnSpacing: 0,
                              //     columns: [
                              //       DataColumn(
                              //         label: Text("Subject"),
                              //       ),
                              //       DataColumn(
                              //         label: Text("Schedule"),
                              //       ),
                              //     ],
                              //     rows: subjectList!.map((Subject subject) {
                              //       return DataRow(cells: [
                              //         DataCell(
                              //           Text(
                              //             subject.name,
                              //             style: theme.textTheme.bodySmall,
                              //           ),
                              //         ),
                              //         DataCell(
                              //           subject.schedule!.isNotEmpty ? Padding(
                              //             padding: const EdgeInsets.symmetric(vertical: 2.0),
                              //             child: Column(
                              //               crossAxisAlignment: CrossAxisAlignment.stretch,
                              //               children: subject.schedule!.map((Schedule? schedule) {
                              //
                              //                 final DateTime date = schedule!.getNextDayTime(schedule);
                              //                 final String startDate = DateFormat("EEEE, h:mma").format(date);
                              //                 final String endDate = DateFormat("h:mma").format(date.add(Duration(hours: 1),));
                              //
                              //                 return Expanded(
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.symmetric(
                              //                       vertical: 1.0,
                              //                     ),
                              //                     child: Text(
                              //                       subjectList.isEmpty ? "N/A" : "$startDate/$endDate",
                              //                       style: theme.textTheme.bodySmall,
                              //                     ),
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //             ),
                              //           ) : Text("N/A")
                              //         ),
                              //       ]);
                              //     }).toList(),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
