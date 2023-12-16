import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';

@RoutePage()
class ResponsiveMobileScreen extends StatefulWidget {
  const ResponsiveMobileScreen({super.key});

  @override
  State<ResponsiveMobileScreen> createState() => _ResponsiveMobileScreenState();
}

class _ResponsiveMobileScreenState extends State<ResponsiveMobileScreen> {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      PngImages.background,
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "St.Jude Agro Industrial Secondary School",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Topas Proper Nabua, Camarines Sur",
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 100),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: Text("Log in as a",
                    //     style: theme.textTheme.bodyMedium!.copyWith(
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 12.0),
                    // SizedBox(
                    //   child: PrimaryButton(
                    //     label: "Instructor",
                    //     onPressed: () {
                    //       auth.updateAuthor("instructor");
                    //       context.pushRoute(const LoginRoute());
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: 12.0),
                    // PrimaryButton(
                    //   label: "Student",
                    //   onPressed: () {
                    //     auth.updateAuthor("student");
                    //     context.pushRoute(const LoginRoute());
                    //   },
                    // ),
                    // const SizedBox(height: 12.0),
                    PrimaryButton(
                      label: "Sign in",
                      onPressed: () {
                        // auth.updateAuthor("admin");
                        context.pushRoute(const LoginRoute());
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Let us help you make your document."),
                            GestureDetector(
                              onTap: () =>
                                  context.pushRoute(const FormsRoute()),
                              child: Text(
                                "Click here to start.",
                                style: TextStyle(
                                  color: ColorTheme.primaryRed,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
