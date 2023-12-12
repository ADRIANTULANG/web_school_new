import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_school/models/user.dart';
import 'package:web_school/networks/instructor.dart';
import 'package:web_school/networks/router/routes.gr.dart';

class Auth extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool isLoading = false;

  /// [showHUD] will trigger to show the waiting widget
  void showHUD(bool value) {
    isLoading = value;
    notifyListeners();
  }

  static TextEditingController controlNumber = TextEditingController();
  static TextEditingController password = TextEditingController();

  String? author;

  /// [updateAuthor] will update whether
  /// the user is instructor, student or admin
  void updateAuthor(String? value) {
    author = value;
    notifyListeners();
  }

  UserModel? user;

  /// [loginAccount] will prompt the user to log in
  Future<void> loginAccount(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final InstructorDB instructorDB =
        Provider.of<InstructorDB>(context, listen: false);

    await db.collection("user").get().then((value) {
      final List<UserModel> userModels = value.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromJson(data);
      }).toList();

      bool authenticated = userModels.any((element) {
        if (element.controlNumber == controlNumber.text &&
            element.password == password.text) {
          user = element;
          updateAuthor(user!.type);
          notifyListeners();
          return true;
        } else {
          return false;
        }
      });

      if (authenticated && user != null) {
        if (user!.type == "instructor") {
          instructorDB.updateInstructorId(user!.id);
          AutoRouter.of(context).replace(WrapperInstructorRoute());
        } else if (user!.type == "student") {
          sp.setString("studentId", user!.id);
          AutoRouter.of(context).replace(WrapperStudentRoute());
        } else if (user!.type == "admin") {
          AutoRouter.of(context).replace(const WrapperAdminRoute());
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "Wrong control number/password.",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.red,
                  ),
                ),
              );
            });
      }
      showHUD(false);
    });
  }

  Future<void> updateUserModelLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final data = sp.getString("userModel");
    user ??= UserModel.fromJson(jsonDecode(data!));
    notifyListeners();
  }

  /// [logOut] lets the user logout and clear the
  /// credentials
  Future<void> logout(BuildContext context) async {
    await auth.signOut().then((value) {
      // !kIsWeb ? AutoRouter.of(context).popUntilRoot()
      //     : AutoRouter.of(context).popUntil((route) => route.isFirst);

      AutoRouter.of(context).popUntil((route) => route.isFirst);
      // AutoRouter.of(context).pop();
      // AutoRouter.of(context).replace(const ResponsiveBuilder());
      clearForm();
    });
  }

  void clearForm() {
    controlNumber.clear();
    password.clear();
    notifyListeners();
  }

  Stream<List<String>>? authListStream;

  Stream<List<String>> getAuth() {
    return db.collection(author!).snapshots().map(_authFromSnapshots);
  }

  List<String> _authFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      if (author == "student") {
        final data = doc.data() as Map<String, dynamic>;
        return data["studentInfo"]["id"] as String;
      } else {
        return doc.get("id") as String;
      }
    }).toList();
  }

  void updateAuthListStream() {
    authListStream = getAuth();
    notifyListeners();
  }
}
