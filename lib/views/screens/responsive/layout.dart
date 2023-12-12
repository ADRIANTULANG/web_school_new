import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:web_school/views/screens/layout/mobile/home.dart';
import 'package:web_school/views/screens/layout/web/home.dart';

@RoutePage()
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ResponsiveMobileScreen();
        } else {
          return ResponsiveWebScreen();
        }
      },
    );
  }
}
