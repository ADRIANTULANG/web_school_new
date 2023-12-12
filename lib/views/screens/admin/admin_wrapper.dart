import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/payment.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/screens/admin/admin_home.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class WrapperAdminScreen extends StatefulWidget {
  const WrapperAdminScreen({super.key});

  @override
  State<WrapperAdminScreen> createState() => _WrapperAdminScreenState();
}

class _WrapperAdminScreenState extends State<WrapperAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StudentDB studentDB =
          Provider.of<StudentDB>(context, listen: false);
      studentDB.updateStudentListStream();
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.updateInstructorListStream();
      final PaymentDB paymentDB =
          Provider.of<PaymentDB>(context, listen: false);
      paymentDB.updatePaymentModelStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    final PaymentDB paymentDB = Provider.of<PaymentDB>(context);
    final AdminDB adminDB = Provider.of<AdminDB>(context);

    return Scaffold(
      body: SafeArea(
        child: StreamWrapper<List<Instructor>>(
          stream: adminDB.instructorListStream,
          child: (instructorList) {
            return StreamWrapper<List<Payment>>(
                stream: paymentDB.paymentModelStream,
                child: (paymentList) {
                  return StreamWrapper<List<ApplicationInfo>>(
                    stream: studentDB.studentListStream,
                    child: (studentList) {
                      return AdminHomeScreen(
                        instructorList: instructorList!,
                        paymentList: paymentList!,
                        studentList: studentList!,
                      );
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}
