import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/hover/button.dart';

@RoutePage()
class AdminInstructorGradeScreen extends StatefulWidget {
  const AdminInstructorGradeScreen({super.key});

  @override
  State<AdminInstructorGradeScreen> createState() => _AdminInstructorGradeScreenState();
}

class _AdminInstructorGradeScreenState extends State<AdminInstructorGradeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);
      adminDB.updateGeneralYearLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructor"),
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.primaryRed,
        onPressed: () {
          context.pushRoute( AdminAddInstructorRoute());
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: adminDB.juniorYear
              ? adminDB.generalJuniorList.length
              : adminDB.generalSeniorList.length,
          itemBuilder: (context, index) {
            return OnHoverButton(
              onTap: () {
                adminDB.updateGeneralGrade(
                  adminDB.juniorYear
                      ? adminDB.generalJuniorList[index]
                      : adminDB.generalSeniorList[index],
                );
                context.pushRoute(const AdminInstructorSectionRoute());
              },
              builder: (isHovered) => Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      adminDB.juniorYear
                          ? adminDB.generalJuniorList[index].label!
                          : adminDB.generalSeniorList[index].label!,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: isHovered ? Colors.white : Colors.black87,
                      ),
                    ),
                    Icon(Icons.arrow_right,
                      color: isHovered ? Colors.white : Colors.black87,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
