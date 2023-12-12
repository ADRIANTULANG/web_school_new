import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/application.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/networks/instructor.dart';
import 'package:web_school/networks/payment.dart';
import 'package:web_school/networks/router/routes.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/school_app.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdminDB>(create: (context) => AdminDB()),
        ChangeNotifierProvider<Application>(create: (context) => Application()),
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<Commons>(create: (context) => Commons()),
        ChangeNotifierProvider<InstructorDB>(
            create: (context) => InstructorDB()),
        ChangeNotifierProvider<PaymentDB>(create: (context) => PaymentDB()),
        ChangeNotifierProvider<StudentDB>(create: (context) => StudentDB()),
      ],
      child: SchoolApp(
        appRouter: appRouter,
      ),
    );
  }
}
