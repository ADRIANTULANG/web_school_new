import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/auth.dart';
// import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/hover/tile_button.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    this.isMobile = false,
    super.key,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final Auth auth = Provider.of<Auth>(context);

    final style = theme.textTheme.bodyMedium!.copyWith();

    return SizedBox(
      height: size.height,
      child: Drawer(
        width: 230,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 120,
                child: DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          PngImages.background,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        "Administrator",
                        style: style,
                      ),
                    ],
                  ),
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 0 ? Colors.redAccent : null,
                onTap: () {
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(0);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil((route) {
                      print(route.settings.name);
                      return route.settings.name == "WrapperAdminRoute";
                    });
                    adminDB.updateIndexDashboard(0);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Dashboard",
                  style: style,
                ),
                leading: Icon(
                  Icons.dashboard,
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 2 ? Colors.redAccent : null,
                onTap: () {
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(2);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil(
                        (route) => route.settings.name == "WrapperAdminRoute");
                    adminDB.updateIndexDashboard(2);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Teachers",
                  style: style,
                ),
                leading: Icon(
                  Icons.supervised_user_circle_rounded,
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 1 ? Colors.redAccent : null,
                onTap: () {
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(1);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil(
                        (route) => route.settings.name == "WrapperAdminRoute");
                    adminDB.updateIndexDashboard(1);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Students",
                  style: style,
                ),
                leading: Icon(
                  Icons.supervised_user_circle_rounded,
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 3 ? Colors.redAccent : null,
                onTap: () {
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(3);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil(
                        (route) => route.settings.name == "WrapperAdminRoute");
                    adminDB.updateIndexDashboard(3);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Payments",
                  style: style,
                ),
                leading: Icon(
                  Icons.payment,
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 4 ? Colors.redAccent : null,
                onTap: () {
                  adminDB.updateIndexDashboard(4);
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(4);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil(
                        (route) => route.settings.name == "WrapperAdminRoute");
                    adminDB.updateIndexDashboard(4);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Subjects",
                  style: style,
                ),
                leading: Icon(
                  Icons.menu_book,
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 5 ? Colors.redAccent : null,
                onTap: () {
                  adminDB.updateIndexDashboard(5);
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(5);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil(
                        (route) => route.settings.name == "WrapperAdminRoute");
                    adminDB.updateIndexDashboard(5);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Strands",
                  style: style,
                ),
                leading: Icon(
                  Icons.school,
                ),
              ),
              OnHoverListTileButton(
                backgroundColor:
                    adminDB.indexDashboard == 6 ? Colors.redAccent : null,
                onTap: () {
                  adminDB.updateIndexDashboard(6);
                  if (AutoRouter.of(context).root.current.name ==
                      "WrapperAdminRoute") {
                    adminDB.updateIndexDashboard(6);
                    isMobile ? context.popRoute() : false;
                  } else {
                    AutoRouter.of(context).popUntil(
                        (route) => route.settings.name == "WrapperAdminRoute");
                    adminDB.updateIndexDashboard(6);
                    // isMobile ? context.popRoute() : false;
                  }
                },
                title: Text(
                  "Sections",
                  style: style,
                ),
                leading: Icon(
                  Icons.group_work_sharp,
                ),
              ),
              OnHoverListTileButton(
                onTap: () => auth.logout(context),
                title: Text(
                  "Logout",
                  style: style,
                ),
                leading: Icon(
                  Icons.logout,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Container(
    //   height: size.height,
    //   decoration: BoxDecoration(
    //     color: Colors.black12,
    //     borderRadius: BorderRadius.only(
    //       topRight: Radius.circular(12.0),
    //       bottomRight: Radius.circular(12.0),
    //     ),
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text("Admin"),
    //       ),
    //       Divider(),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Row(
    //           children: [
    //             SizedBox(
    //               width: 50,
    //               height: 50,
    //               child: Image.asset(PngImages.background,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             const SizedBox(width: 12.0),
    //             Text("admin"),
    //           ],
    //         ),
    //       ),
    //       Divider(),
    //       ListTile(
    //         title: Text("Dashboard"),
    //         leading: Icon(Icons.dashboard),
    //         onTap: () {},
    //       ),
    //       ListTile(
    //         title: Text("Teachers"),
    //         trailing: Icon(Icons.arrow_back_ios_new,
    //
    //         ),
    //         leading: Icon(Icons.supervised_user_circle_rounded,
    //         ),
    //         onTap: () => context.pushRoute(AdminInstructorListRoute(),
    //         ),
    //       ),
    //       ListTile(
    //         title: Text("Students"),
    //         trailing: Icon(Icons.arrow_back_ios_new),
    //         leading: Icon(Icons.supervised_user_circle_rounded,
    //           size: 25,
    //         ),
    //         onTap: () => context.pushRoute(const AdminStudentsRoute()),
    //       ),
    //       ListTile(
    //         title: Text("Payments"),
    //         trailing: Icon(Icons.arrow_back_ios_new),
    //         leading: Icon(Icons.payment,
    //           size: 25,
    //         ),
    //         onTap: () => context.pushRoute(SummaryPaymentRoute(
    //           applicationInfo: studentList,
    //           paymentList: paymentList,
    //         )),
    //       ),
    //       ListTile(
    //         title: Text("Logout"),
    //         trailing: Icon(Icons.arrow_back_ios_new,
    //
    //         ),
    //         leading: Icon(Icons.logout,
    //         ),
    //         onTap: () {},
    //       ),
    //     ],
    //   ),
    // );
  }
}
