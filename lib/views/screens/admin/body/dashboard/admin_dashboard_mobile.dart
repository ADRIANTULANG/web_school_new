import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/screens/admin/home/components/student_pie.dart';
import 'package:web_school/views/widgets/cards/custom_admin.dart';

class AdminDashboardMobile extends StatelessWidget {
  const AdminDashboardMobile({
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
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    final AdminDB adminDB = Provider.of<AdminDB>(context);

    return Container(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Dashboard",
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12.0),
            Divider(
              color: Colors.black,
            ),
            Column(
              children: [
                SizedBox(
                  width: size.width,
                  child: CustomAdminCard(
                    title: "Total Students: ${studentList.length}",
                    imageIcon: PngImages.students,
                    subtitle: "MANAGE STUDENTS",
                    onTap: () {
                      // context.pushRoute(AdminStudentsListRoute(
                      //     studentList: studentList,
                      //   ),
                      // );
                      adminDB.updateIndexDashboard(1);
                    },
                    color: Colors.deepPurple.shade200,
                    titleSize: 14.0,
                    subtitleSize: 16.0,
                  ),
                ),

                SizedBox(
                  width: size.width,
                  child: CustomAdminCard(
                    title: "Total Teachers: ${instructorList.length}",
                    imageIcon: PngImages.instructors,
                    subtitle: "MANAGE TEACHERS",
                    onTap: () {
                      adminDB.updateIndexDashboard(2);
                    },
                    color: Colors.lightBlue,
                    titleSize: 14.0,
                    subtitleSize: 16.0,
                  ),
                ),

                SizedBox(
                  width: size.width,
                  child: CustomAdminCard(
                    title: "Total Payments: ${paymentList.length}",
                    imageIcon: PngImages.payment,
                    subtitle: "MANAGE PAYMENTS",
                    onTap: () {
                      adminDB.updateIndexDashboard(3);
                    },
                    color: Colors.lightGreen,
                    titleSize: 14.0,
                    subtitleSize: 16.0,
                  ),

                ),
              ],
            ),
            const SizedBox(height: 12.0),
            StudentPieChart(
              studentList: studentList,
            ),
          ],
        ),
      ),
    );
  }
}
