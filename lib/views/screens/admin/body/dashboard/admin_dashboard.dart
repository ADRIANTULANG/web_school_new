import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/views/screens/admin/body/dashboard/admin_dashboard_mobile.dart';
import 'package:web_school/views/screens/admin/body/dashboard/admin_dashboard_tablet.dart';

class CustomAdminDashboardScreen extends StatelessWidget {
  const CustomAdminDashboardScreen({
    required this.studentList,
    required this.instructorList,
    required this.paymentList,
    super.key,
  });

  final List<ApplicationInfo> studentList;
  final List<Instructor> instructorList;
  final List<Payment> paymentList;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => AdminDashboardMobile(
        studentList: studentList,
        instructorList: instructorList,
        paymentList: paymentList,
      ),
      tablet: (context) => AdminDashboardTablet(
        studentList: studentList,
        instructorList: instructorList,
        paymentList: paymentList,
      ),
      desktop: (context) => AdminDashboardTablet(
        studentList: studentList,
        instructorList: instructorList,
        paymentList: paymentList,
      ),
    );
  }
}
