import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar_mobile.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar_tablet.dart';

class AdminNavigationBar extends StatelessWidget {
  const AdminNavigationBar({
    required this.child,
    super.key,
  });

  final Widget child;


  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => AdminNavigationBarMobile(
        child: child,
      ),
      tablet: (context) => AdminNavigationBarTablet(
        child: child,
      ),
      desktop: (context) => AdminNavigationBarTablet(
        child: child,
      ),
    );
  }
}
