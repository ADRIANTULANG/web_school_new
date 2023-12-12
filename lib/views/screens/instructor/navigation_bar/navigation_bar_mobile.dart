import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/views/widgets/drawer/instructor_drawer.dart';

class InstructorNavigationBarMobile extends StatelessWidget {
  const InstructorNavigationBarMobile({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => auth.logout(context),
            child: Text("Logout",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: InstructorDrawer(
        isMobile: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            child,
          ],
        ),
      ),
    );
  }
}
