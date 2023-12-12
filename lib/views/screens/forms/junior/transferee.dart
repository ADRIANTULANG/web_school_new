import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/application.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';
import 'package:web_school/views/widgets/forms/emergency.dart';
import 'package:web_school/views/widgets/forms/family.dart';
import 'package:web_school/views/widgets/forms/personal.dart';
import 'package:web_school/views/widgets/forms/residence.dart';
import 'package:web_school/views/widgets/forms/school.dart';

@RoutePage()
class TransfereeJuniorScreen extends StatelessWidget {
  const TransfereeJuniorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Application application = Provider.of<Application>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.popRoute();
            application.clearForm();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Application Form"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: application.isLoading,
        child: Form(
          key: Application.formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "For Transferees in Junior High School Enrollment Form",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SchoolInfoForm(),
                        const BasicPersonalInfoForm(),
                        const EmergencyForm(),
                        const ResidenceForm(),
                        const FamilyInformationForm(),
                        const SizedBox(height: 24.0),
                        Center(
                          child: SizedBox(
                            width: size.width * 0.2,
                            child: PrimaryButton(
                              onPressed: () async {
                                if (Application.formKey.currentState!.validate()) {
                                  await application.submitApplicationForm(context,
                                    isJunior: true,
                                    isTransferee: true,
                                  ).then((value) {
                                    context.popRoute();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(
                                              "Submitted Successfully",
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          );
                                        });
                                  });
                                }
                              },
                              label: "Submit",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
