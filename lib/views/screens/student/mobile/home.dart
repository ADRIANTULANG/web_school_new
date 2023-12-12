import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/user.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/screens/student/mobile/grades/grades.dart';
import 'package:web_school/views/screens/student/body/profile/payment.dart';
import 'package:web_school/views/screens/student/mobile/profile/change_pass.dart';
import 'package:web_school/views/screens/student/mobile/profile/enrollment.dart';
import 'package:web_school/views/screens/student/mobile/profile/profile.dart';
import 'package:web_school/views/screens/student/mobile/profile/schedule.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';
import 'package:web_school/views/widgets/drawer/student_drawer.dart';

@RoutePage()
class StudentMobileHomeScreen extends StatefulWidget {
  const StudentMobileHomeScreen({
    required this.userModel,
    super.key,
  });

  final UserModel userModel;

  @override
  State<StudentMobileHomeScreen> createState() => _StudentMobileHomeScreenState();
}

class _StudentMobileHomeScreenState extends State<StudentMobileHomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB = Provider.of<StudentDB>(context, listen: false);
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.getStudentIdLocal().then((_) {
        studentDB.updateStudentStream(adminDB.studentId!);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: const StudentDrawer(),
        body: StreamWrapper<ApplicationInfo>(
          stream: studentDB.studentStream,
          child: (applicationInfo) {

            final List<Widget> screenList = [
              StudentMobileProfileScreen(applicationInfo: applicationInfo!),
              StudentMobileGradeScreen(applicationInfo: applicationInfo),
              StudentMobileEnrollmentScreen(applicationInfo: applicationInfo),
              StudentMobileScheduleScreen(applicationInfo: applicationInfo,),
              StudentPaymentHomeScreen(applicationInfo: applicationInfo),
              StudentMobileChangePassScreen(currentPassword: applicationInfo.userModel.password),
            ];

            return screenList[studentDB.studentIndex];
          },
        ),
      ),
    );
  }
}
