import 'package:flutter/material.dart';
import 'package:web_school/views/widgets/drawer/admin_drawer.dart';
import 'package:web_school/views/widgets/app_bar/custom.dart';

class AdminNavigationBarTablet extends StatelessWidget {
  const AdminNavigationBarTablet({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminDrawer(),
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
