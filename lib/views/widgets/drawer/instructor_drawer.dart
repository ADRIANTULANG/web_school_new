import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/networks/instructor.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/hover/tile_button.dart';

class InstructorDrawer extends StatelessWidget {
  const InstructorDrawer({
    this.isMobile = false,
    super.key,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final InstructorDB instructorDB = Provider.of<InstructorDB>(context);
    final Auth auth = Provider.of<Auth>(context);
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Drawer(
        width: 230,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawerHeader(
                child: Image.asset(
                  PngImages.background,
                  scale: 5,
                ),
              ),
              Text(
                "St. Jude Agro-Industrial Secondary School",
                style: theme.textTheme.bodyMedium!.copyWith(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              OnHoverListTileButton(
                backgroundColor:
                    instructorDB.drawerIndex == 0 ? Colors.redAccent : null,
                leading: Icon(CupertinoIcons.home),
                onTap: () {
                  print(AutoRouter.of(context).root.current.name);
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperInstructorRoute") {
                    instructorDB.updateDrawerIndex(0);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil((route) =>
                        route.settings.name == "WrapperInstructorRoute");
                    instructorDB.updateDrawerIndex(0);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Home",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    instructorDB.drawerIndex == 1 ? Colors.redAccent : null,
                leading: Icon(CupertinoIcons.profile_circled),
                onTap: () {
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperInstructorRoute") {
                    instructorDB.updateDrawerIndex(1);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil((route) =>
                        route.settings.name == "WrapperInstructorRoute");
                    instructorDB.updateDrawerIndex(1);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Profile",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    instructorDB.drawerIndex == 2 ? Colors.redAccent : null,
                leading: Icon(CupertinoIcons.group_solid),
                onTap: () {
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperInstructorRoute") {
                    instructorDB.updateDrawerIndex(2);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil((route) =>
                        route.settings.name == "WrapperInstructorRoute");
                    instructorDB.updateDrawerIndex(2);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Adviser's Students",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OnHoverListTileButton(
                onTap: () {
                  auth.logout(context);
                },
                leading: Icon(Icons.logout),
                title: Text(
                  "Logout",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
