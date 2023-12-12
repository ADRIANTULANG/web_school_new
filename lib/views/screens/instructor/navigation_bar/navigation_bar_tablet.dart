import 'package:flutter/material.dart';
import 'package:web_school/views/widgets/app_bar/custom.dart';
import 'package:web_school/views/widgets/drawer/instructor_drawer.dart';

class InstructorNavigationBarTablet extends StatelessWidget {
  const InstructorNavigationBarTablet({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstructorDrawer(),
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
