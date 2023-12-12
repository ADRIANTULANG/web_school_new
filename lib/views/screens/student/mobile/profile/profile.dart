import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/date.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/student/subject.dart';
import 'package:web_school/networks/admin.dart';
// import 'package:web_school/networks/auth.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class StudentMobileProfileScreen extends StatefulWidget {
  const StudentMobileProfileScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentMobileProfileScreen> createState() =>
      _StudentMobileProfileScreenState();
}

class _StudentMobileProfileScreenState
    extends State<StudentMobileProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB =
          Provider.of<StudentDB>(context, listen: false);
      // final Auth auth = Provider.of<Auth>(context, listen: false);
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.getStudentIdLocal().then((_) {
        studentDB.updateListSubjectStream(adminDB.studentId!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    final ThemeData theme = Theme.of(context);

    final personal = widget.applicationInfo.personalInfo;

    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: StreamWrapper<List<Subject>>(
            stream: studentDB.listSubjectStream,
            child: (subjectList) {
              final DateTime now = DateTime.now().add(Duration(days: 1));
              final List<Subject> dateList = [];

              subjectList!.map((subject) {
                subject.schedule!.forEach((element) {
                  final dateTime = element.getNextDayTime(element);

                  if (now.toDayOfWeek() == dateTime.toDayOfWeek()) {
                    dateList.add(subject);
                  }
                });
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${personal.firstName} ${personal.lastName}",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12.0),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Text(
                            "Admission Status: ${studentDB.enrollmentStatus(widget.applicationInfo.studentInfo)}"),
                      ),
                      const SizedBox(height: 24.0),

                      widget.applicationInfo.studentInfo.enrolled
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "This is your schedule today",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: dateList.length,
                                  itemBuilder: (context, index) {
                                    final schedule = dateList[index]
                                        .schedule!
                                        .map((schedule) {
                                      if (schedule
                                              .getNextDayTime(schedule)
                                              .toDayOfWeek() ==
                                          now.toDayOfWeek()) {
                                        final unformattedTime =
                                            schedule.getNextDayTime(schedule);
                                        final formattedTime =
                                            DateFormat("hh:mm aa")
                                                .format(unformattedTime);
                                        return formattedTime;
                                      }
                                    }).toList();

                                    final subjectName = dateList[index].name;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(subjectName[0]),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  subjectName,
                                                  style: theme
                                                      .textTheme.titleSmall,
                                                ),
                                                Text(
                                                  "${now.toDayOfWeek()}",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  "${schedule.where((element) => element != null)}",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : Center(
                              child: Text(""),
                            ),

                      // Expanded(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.red,
                      //       borderRadius: BorderRadius.only(
                      //         topRight: Radius.circular(12.0),
                      //         topLeft: Radius.circular(12.0),
                      //       ),
                      //     ),
                      //     child: Column(
                      //       children: [
                      //         Text("Your schedule today"),
                      //         Wrap(
                      //           children: [
                      //             Card(
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text("Monday"),
                      //                   Text("English"),
                      //                   Text("12:00AM")
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
