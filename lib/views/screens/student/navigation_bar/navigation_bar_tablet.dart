import 'package:flutter/material.dart';
import 'package:web_school/views/widgets/app_bar/custom.dart';
import 'package:web_school/views/widgets/drawer/student_drawer.dart';

class StudentNavigationBarTablet extends StatelessWidget {
  const StudentNavigationBarTablet({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentDrawer(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(),
                child,
              ],
            ),
          ),
        ),

      ],
    );
  }
}
