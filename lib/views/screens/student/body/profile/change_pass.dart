import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/buttons/secondary.dart';
import 'package:web_school/views/widgets/fields/password.dart';

@RoutePage()
class StudentWebChangePassScreen extends StatefulWidget {
  const StudentWebChangePassScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentWebChangePassScreen> createState() =>
      _StudentWebChangePassScreenState();
}

class _StudentWebChangePassScreenState
    extends State<StudentWebChangePassScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Future<void> changePassword(
    String id,
    BuildContext context, {
    required String currentPassword,
  }) async {
    if (newPassword.text == confirmPassword.text) {
      debugPrint("Changing Password");
      // await firebaseAuth.currentUser!.updatePassword(newPassword.text);
      await FirebaseFirestore.instance.collection("student").doc(id).update(
        {
          "userModel.password": newPassword.text,
        },
      );
      await FirebaseFirestore.instance.collection('user').doc(id).update({
        "password": newPassword.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong Password!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StudentDB studentDB = Provider.of<StudentDB>(context);
    return Form(
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
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  PasswordTextField(
                    fieldKey: StudentDB.oldPasswordKey,
                    controller: oldPassword,
                    label: "Old Password",
                    validator: Commons.forcedTextValidator,
                    hintText: "Enter",
                  ),
                  const SizedBox(height: 24.0),
                  PasswordTextField(
                    fieldKey: StudentDB.newPasswordKey,
                    controller: newPassword,
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
                    controller: confirmPassword,
                    label: "Retype Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else if (value != newPassword.text) {
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
                            changePassword(
                              widget.applicationInfo.userModel.id,
                              context,
                              currentPassword:
                                  widget.applicationInfo.userModel.password,
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
                            // print(StudentDB.oldPassword.text);
                            // print(StudentDB.newPassword.text);
                            // print(StudentDB.confirmPassword.text);

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
    );
  }
}
