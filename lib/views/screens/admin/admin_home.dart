import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/views/screens/admin/body/dashboard/admin_dashboard.dart';
import 'package:web_school/views/screens/admin/body/instructor/general/instructor_list.dart';
import 'package:web_school/views/screens/admin/body/payment/payment_list.dart';
import 'package:web_school/views/screens/admin/body/student/student_list.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar.dart';
import 'package:web_school/views/screens/sections/sections_page.dart';
import 'package:web_school/views/screens/strands/strands_page.dart';
import 'package:web_school/views/screens/subjects/subject_page.dart';

@RoutePage()
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({
    required this.studentList,
    required this.paymentList,
    required this.instructorList,
    super.key,
  });

  final List<ApplicationInfo> studentList;
  final List<Payment> paymentList;
  final List<Instructor> instructorList;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    // print(studentList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdminDB adminDB = Provider.of<AdminDB>(context);

    final List<Widget> dashboardList = [
      CustomAdminDashboardScreen(
        studentList: widget.studentList,
        instructorList: widget.instructorList,
        paymentList: widget.paymentList,
      ),
      AdminStudentsListScreen(
        studentList: widget.studentList,
      ),
      AdminInstructorListScreen(
        instructorList: widget.instructorList,
      ),
      SummaryPaymentScreen(
        applicationInfo: widget.studentList,
        paymentList: widget.paymentList,
      ),
      SubjectsPage(),
      StrandPage(),
      SectionsPage()
    ];

    return SafeArea(
      child: Scaffold(
        body: AdminNavigationBar(
          child: dashboardList[adminDB.indexDashboard],
        ),
      ),
    );
  }
}
