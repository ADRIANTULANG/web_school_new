import 'package:flutter/material.dart';
import 'package:web_school/networks/router/routes.dart';
import 'package:web_school/values/theme.dart';

class SchoolApp extends StatelessWidget {
  const SchoolApp({
    required this.appRouter,
    super.key,
  });

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: CustomTheme.themeData,
      routerConfig: appRouter.config(),
    );
  }
}
