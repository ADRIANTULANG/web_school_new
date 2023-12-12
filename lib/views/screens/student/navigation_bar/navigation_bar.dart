import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_school/views/screens/student/navigation_bar/navigation_bar_mobile.dart';
import 'package:web_school/views/screens/student/navigation_bar/navigation_bar_tablet.dart';

class StudentNavigationBar extends StatelessWidget {
  const StudentNavigationBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (context) => StudentNavigationBarMobile(
          child: child,
        ),
        tablet: (context) => StudentNavigationBarTablet(
          child: child,
        ),
        desktop: (context) => StudentNavigationBarTablet(
          child: child,
        ),
      ),
    );
  }
}
