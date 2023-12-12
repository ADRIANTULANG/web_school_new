import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:web_school/networks/auth.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';

@RoutePage()
class ResponsiveWebScreen extends StatefulWidget {
  const ResponsiveWebScreen({super.key});

  @override
  State<ResponsiveWebScreen> createState() => _ResponsiveWebScreenState();
}

class _ResponsiveWebScreenState extends State<ResponsiveWebScreen> {
  @override
  Widget build(BuildContext context) {
    // final Auth auth = Provider.of<Auth>(context);
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              color: Colors.black.withOpacity(0.9),
            ),
            SizedBox(
              height: size.height,
              width: size.width,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  PngImages.schoolBg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: size.height,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
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
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Topas Proper Nabua, Camarines Sur",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 100),
                        // SizedBox(
                        //   width: size.width * 0.3,
                        //   child: Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text(
                        //       "Log in as a",
                        //       style: theme.textTheme.bodyMedium!.copyWith(
                        //         fontWeight: FontWeight.w700,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 12.0),
                        // SizedBox(
                        //   width: size.width * 0.3,
                        //   child: PrimaryButton(
                        //     label: "Instructor",
                        //     onPressed: () {
                        //       auth.updateAuthor("instructor");
                        //       context.router.push(LoginRoute());
                        //     },
                        //   ),
                        // ),
                        // const SizedBox(height: 12.0),
                        // SizedBox(
                        //   width: size.width * 0.3,
                        //   child: PrimaryButton(
                        //     label: "Student",
                        //     onPressed: () {
                        //       auth.updateAuthor("student");
                        //       context.router.push(LoginRoute());
                        //     },
                        //   ),
                        // ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          width: size.width * 0.3,
                          child: PrimaryButton(
                            label: "Sign in",
                            onPressed: () {
                              // auth.updateAuthor("admin");
                              context.router.push(LoginRoute());
                            },
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Container(
                          width: size.width * 0.3,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
