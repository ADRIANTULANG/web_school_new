import 'package:flutter/material.dart';
import 'package:web_school/views/widgets/drawer/admin_drawer.dart';
import 'package:web_school/views/widgets/app_bar/custom.dart';

class AdminNavigationBarWeb extends StatelessWidget {
  const AdminNavigationBarWeb({
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
        CustomAppBar(),
      ],
    );
  }
}
