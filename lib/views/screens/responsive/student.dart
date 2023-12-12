// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:web_school/models/user.dart';
// import 'package:web_school/views/screens/layout/web/student/instructor_wrapper.dart';
// import 'package:web_school/views/screens/student/mobile/instructor_wrapper.dart';
//
// @RoutePage()
// class StudentLayoutBuilder extends StatelessWidget {
//   const StudentLayoutBuilder({
//     required this.userModel,
//     super.key,
//   });
//
//   final UserModel userModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth < 600) {
//           return StudentMobileHomeScreen(
//             userModel: userModel,
//           );
//         } else {
//           return WebStudentHomeScreen();
//         }
//       },
//     );
//   }
// }
