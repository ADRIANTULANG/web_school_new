import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_school/views/screens/instructor/navigation_bar/navigation_bar_mobile.dart';
import 'package:web_school/views/screens/instructor/navigation_bar/navigation_bar_tablet.dart';

class InstructorNavigationBar extends StatelessWidget {
  const InstructorNavigationBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (context) => InstructorNavigationBarMobile(
          child: child,
        ),
        tablet: (context) => InstructorNavigationBarTablet(
          child: child,
        ),
        desktop: (context) => InstructorNavigationBarTablet(
          child: child,
        ),
      ),
    );
  }
}
