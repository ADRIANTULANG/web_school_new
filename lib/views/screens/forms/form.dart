import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';

@RoutePage()
class FormsScreen extends StatelessWidget {
  static String route = "/forms";
  const FormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    // final Application application = Provider.of<Application>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              width: size.width * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Choose your enrollment type:",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 48.0),
                    PrimaryButton(
                      onPressed: () {
                        context.pushRoute(const IncomingJuniorFormRoute());
                      },
                      label: "For Incoming Grade 7",
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: () {
                        context.pushRoute(const TransfereeJuniorRoute());
                      },
                      label: "For Transferees in Junior High School",
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: () {
                        context.pushRoute(const ContinueJuniorRoute());
                      },
                      label: "For Continouing Junior High School Learners",
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: () {
                        context.pushRoute(const NewSeniorRoute());
                      },
                      label:
                          "For New Senior High School Learners from SJAISS (Gr.11)",
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: () {
                        context.pushRoute(const OtherSchoolRoute());
                      },
                      label:
                          "For New Senior High School Learners from Other Schools",
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: () {
                        context.pushRoute(const ContinuingSeniorRoute());
                      },
                      label: "For Continouing Senior High School Learners",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
