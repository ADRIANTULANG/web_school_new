import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/screens/student/body/profile/change_pass.dart';
import 'package:web_school/views/screens/student/body/profile/enrollment.dart';
import 'package:web_school/views/screens/student/body/profile/grades/grades.dart';
import 'package:web_school/views/screens/student/body/profile/profile.dart';
import 'package:web_school/views/screens/student/body/profile/schedule.dart';
import 'package:web_school/views/screens/student/body/profile/payment.dart';
import 'package:web_school/views/screens/student/navigation_bar/navigation_bar.dart';

@RoutePage()
class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  Widget build(BuildContext context) {

    final StudentDB studentDB = Provider.of<StudentDB>(context);

    final List<Widget> screenList = [
      StudentWebProfileScreen(
        applicationInfo: applicationInfo,
      ),
      StudentWebGradesScreen(
        applicationInfo: applicationInfo,
      ),
      StudentWebEnrollmentScreen(
        applicationInfo: applicationInfo,
      ),
      StudentWebScheduleScreen(
        applicationInfo: applicationInfo,
      ),
      StudentPaymentHomeScreen(
        applicationInfo: applicationInfo,
      ),
      StudentWebChangePassScreen(
        applicationInfo: applicationInfo,
      ),
    ];


    return Scaffold(
      body: SafeArea(
        child: StudentNavigationBar(
          child: screenList[studentDB.studentIndex],
        ),
      ),
    );
  }
}
