import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/networks/instructor.dart';
import 'package:web_school/views/screens/adviser/adviser.dart';
import 'package:web_school/views/screens/instructor/body/profile/profile.dart';
import 'package:web_school/views/screens/instructor/body/students/student_list.dart';
import 'package:web_school/views/screens/instructor/navigation_bar/navigation_bar.dart';

class InstructorHomeScreen extends StatelessWidget {
  const InstructorHomeScreen({
    required this.studentList,
    required this.instructor,
    super.key,
  });

  final List<ApplicationInfo> studentList;
  final Instructor instructor;

  @override
  Widget build(BuildContext context) {
    final InstructorDB instructorDB = Provider.of<InstructorDB>(context);

    final List<Widget> screenList = [
      InstructorStudentScreen(
        studentList: studentList,
        instructor: instructor,
      ),
      InstructorProfileScreen(
        instructor: instructor,
      ),
      AdviserScreen(
        instructorDetails: instructor,
      )
    ];

    return Scaffold(
      body: SafeArea(
        child: InstructorNavigationBar(
          child: screenList[instructorDB.drawerIndex],
        ),
      ),
    );
  }
}
