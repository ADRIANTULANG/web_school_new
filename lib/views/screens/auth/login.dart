import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/values/strings/api/twilio.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';
import 'package:web_school/views/widgets/fields/password.dart';
import 'package:web_school/views/widgets/fields/primary.dart';
import '../../../models/option.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> loginKey =
      GlobalKey<FormState>(debugLabel: "loginKey");

  final GlobalKey<FormFieldState> emailKey =
      GlobalKey<FormFieldState>(debugLabel: "emailKey");
  final GlobalKey<FormFieldState> passwordKey =
      GlobalKey<FormFieldState>(debugLabel: "passwordKey");

  addSubject() async {
    CollectionReference collectionSectionList =
        FirebaseFirestore.instance.collection('sectionList');

    List<SelectionOption> sectionList = [
      const SelectionOption(id: "0", label: "A"),
      const SelectionOption(id: "1", label: "B"),
    ];
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var section in sectionList) {
      DocumentReference docRef =
          collectionSectionList.doc(section.id.toString());
      batch.set(docRef, section.toJson());
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: loginKey,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
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
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Topas Proper Nabua, Camarines Sur",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: size.width * (kIsWeb ? 0.5 : 0.8),
                          child: PrimaryTextField(
                            fieldKey: emailKey,
                            label: "Username",
                            controller: Auth.controlNumber,
                            hintText: "Username",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          width: size.width * (kIsWeb ? 0.5 : 0.8),
                          child: PasswordTextField(
                            fieldKey: passwordKey,
                            label: "Password",
                            controller: Auth.password,
                            hintText: "Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: size.width * (kIsWeb ? 0.5 : 0.8),
                          child: PrimaryButton(
                            onPressed: () async {
                              if (loginKey.currentState!.validate()) {
                                auth.loginAccount(context);
                              }
                            },
                            label: "Login",
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextButton(
                          onPressed: () {
                            // addSubject();
                            context.router.pushNamed("/");
                            auth.clearForm();
                            // sendSMS();
                          },
                          child: const Text("Return to main screen"),
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

  Future<void> sendSMS() async {
    final Uri uri = Uri.https(TwilioApi.BASE_URL, TwilioApi.message);

    await http
        .post(
      uri,
      body: {
        // "to": phoneNumber.text,
        "To": "+639505611018",
        "From": "+12055709584",
        "Body": "START",
      },
      headers: TwilioApi.headers,
    )
        .then((http.Response response) {
      debugPrint(uri.toString());
      print(TwilioApi.headers);
      debugPrint("Status Code: ${response.statusCode}");
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        debugPrint(response.body);
      } else {
        throw "${response.body}";
      }
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      throw "Time exceeded.";
    }).onError((error, stackTrace) {
      debugPrint("Error: $error");
      debugPrint("Stacktrace: $stackTrace");
    });
  }
}
