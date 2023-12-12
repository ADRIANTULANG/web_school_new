import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/buttons/secondary.dart';
import 'package:web_school/views/widgets/fields/password.dart';

@RoutePage()
class StudentMobileChangePassScreen extends StatelessWidget {
  const StudentMobileChangePassScreen({
    required this.currentPassword,
    super.key,
  });
  final String currentPassword;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StudentDB studentDB = Provider.of<StudentDB>(context);

    return Scaffold(
      body: Form(
        key: StudentDB.changePassFormKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Change Password",
                style: theme.textTheme.titleSmall,
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 8.0,
              //     horizontal: 12.0,
              //   ),
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12.0),
              //     color: ColorTheme.primaryYellow,
              //   ),
              //   child: Text(
              //     "Change Password",
              //     style: theme.textTheme.titleSmall,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    PasswordTextField(
                      fieldKey: StudentDB.oldPasswordKey,
                      controller: StudentDB.oldPassword,
                      label: "Old Password",
                      validator: Commons.forcedTextValidator,
                      hintText: "Enter",
                    ),
                    const SizedBox(height: 24.0),
                    PasswordTextField(
                      fieldKey: StudentDB.newPasswordKey,
                      controller: StudentDB.newPassword,
                      label: "New Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        } else if (value.length < 6) {
                          return "Please input more than 6 characters.";
                        } else {
                          return null;
                        }
                      },
                      hintText: "Enter",
                    ),
                    const SizedBox(height: 24.0),
                    PasswordTextField(
                      fieldKey: StudentDB.confirmPasswordKey,
                      controller: StudentDB.confirmPassword,
                      label: "Retype Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        } else if (value != StudentDB.newPassword.text) {
                          return "Password do not match";
                        } else {
                          return null;
                        }
                      },
                      hintText: "Enter",
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () {
                              // if (StudentDB.changePassFormKey.currentState!
                              //     .validate()) {
                              studentDB.changePassword(
                                "",
                                context,
                                currentPassword: currentPassword,
                              );
                              // }
                            },
                            label: "Ok",
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () {
                              studentDB.clearPassword();
                              context.popRoute();
                            },
                            label: "Cancel",
                            backgroundColor: ColorTheme.primaryYellow,
                            color: ColorTheme.primaryBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
