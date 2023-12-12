// import 'package:auto_route/annotations.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:web_school/models/application/application.dart';
// import 'package:web_school/networks/admin.dart';
// import 'package:web_school/networks/student_drawer.dart';
// import 'package:web_school/views/screens/student/mobile/payment/instructor_wrapper.dart';
// import 'package:web_school/views/screens/student/web/profile/change_pass.dart';
// import 'package:web_school/views/screens/student/web/profile/enrollment.dart';
// import 'package:web_school/views/screens/student/web/profile/grades.dart';
// import 'package:web_school/views/screens/student/web/profile/profile.dart';
// import 'package:web_school/views/screens/student/web/profile/schedule.dart';
// import 'package:web_school/views/widgets/body/wrapper/stream.dart';
// import 'package:web_school/views/widgets/drawer/student_drawer.dart';
//
// @RoutePage()
// class WebStudentHomeScreen extends StatefulWidget {
//   const WebStudentHomeScreen({
//     super.key,
//   });
//
//
//   @override
//   State<WebStudentHomeScreen> createState() => _WebStudentHomeScreenState();
// }
//
// class _WebStudentHomeScreenState extends State<WebStudentHomeScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final StudentDB studentDB = Provider.of<StudentDB>(context, listen: false);
//       final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
//       adminDB.getStudentIdLocal().then((_) {
//         studentDB.updateStudentStream(adminDB.studentId!);
//       });
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final ThemeData theme = Theme.of(context);
//     final StudentDB studentDB = Provider.of<StudentDB>(context);
//
//     return Scaffold(
//       body: StreamWrapper<ApplicationInfo>(
//         stream: studentDB.studentStream,
//         child: (applicationInfo) {
//
//           final firstName = applicationInfo!.personalInfo.firstName;
//           final lastName = applicationInfo.personalInfo.lastName;
//           return Row(
//             children: [
//               StudentDrawer(),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text("Welcome, $firstName $lastName",
//                         style: theme.textTheme.titleSmall,
//                       ),
//                       Expanded(
//                         child: PageView.builder(
//                           itemCount: 5,
//                           itemBuilder: (context, index) {
//
//                             final List<Widget> screenList = [
//                               StudentWebProfileScreen(
//                                 applicationInfo: applicationInfo,
//                               ),
//                               StudentWebGradesScreen(
//                                 applicationInfo: applicationInfo,
//                               ),
//                               StudentWebEnrollmentScreen(
//                                 applicationInfo: applicationInfo,
//                               ),
//                               StudentWebScheduleScreen(
//                                 applicationInfo: applicationInfo,
//                               ),
//                               StudentPaymentHomeScreen(
//                                 applicationInfo: applicationInfo,
//                               ),
//                               StudentWebChangePassScreen(
//                                 applicationInfo: applicationInfo,
//                               ),
//                             ];
//
//                             return screenList[studentDB.studentIndex];
//                           }
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }
//       ),
//     );
//   }
// }
