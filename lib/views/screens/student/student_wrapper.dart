import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/screens/student/student_home.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class WrapperStudentScreen extends StatefulWidget {
  const WrapperStudentScreen({super.key});

  @override
  State<WrapperStudentScreen> createState() => _WrapperStudentScreenState();
}

class _WrapperStudentScreenState extends State<WrapperStudentScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB = Provider.of<StudentDB>(context, listen: false);
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.getStudentIdLocal().then((value) {
        studentDB.updateStudentStream(adminDB.studentId!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final StudentDB studentDB = Provider.of<StudentDB>(context);

    return Scaffold(
      body: SafeArea(
        child: StreamWrapper<ApplicationInfo>(
          stream: studentDB.studentStream,
          child: (applicationInfo) {
            return StudentHomeScreen(
              applicationInfo: applicationInfo!,
            );
          },
        ),
      ),
    );
  }
}
