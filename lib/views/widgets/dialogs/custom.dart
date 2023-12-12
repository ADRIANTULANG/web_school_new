import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/networks/payment.dart';
import 'package:web_school/values/strings/images.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';
import 'package:web_school/views/widgets/fields/primary.dart';

class CustomDialog {
  void showAgree(
    BuildContext context, {
    required Function()? onTap,
    required String message,
    String? rightText,
    String? leftText,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Divider(
                height: 0,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.popRoute(),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              leftText ?? "Cancel",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF2194FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onTap,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              rightText ?? "Yes",
                              style: TextStyle(
                                color: Color(0xFF2194FF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void assignSection(
    BuildContext context, {
    required Function() leftTap,
    required Function() rightTap,
    required String message,
    String? rightText,
    String? leftText,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              Divider(
                height: 0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: leftTap,
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              leftText ?? "Cancel",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2194FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: rightTap,
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              rightText ?? "Yes",
                              style: TextStyle(
                                color: Color(0xFF2194FF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showPayment(BuildContext context, ApplicationInfo applicationInfo) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final PaymentDB paymentDB = Provider.of<PaymentDB>(context, listen: false);
    final FirebaseFirestore db = FirebaseFirestore.instance;

    final ThemeData theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enrollment Payment"),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Description:",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Enrollment fee (Additional if transferee)",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Please pay to the following credentials:",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Name: Delmar",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      "Account number: +639684059727",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Image.asset(PngImages.paymentQr),
                    const SizedBox(height: 24.0),
                    Text(
                      "Please choose what category are you in?",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Wrap(
                      spacing: 4.0,
                      children: paymentDB.paymentCategoryList
                          .map((PaymentCategory value) {
                        return PrimaryButton(
                          onPressed: () {
                            setState(() {
                              paymentDB.paymentCategory = value;
                            });
                          },
                          label: value.paymentCategory,
                          color: value.id == paymentDB.paymentCategory?.id
                              ? Colors.white
                              : Colors.black,
                          backgroundColor:
                              value.id == paymentDB.paymentCategory?.id
                                  ? Colors.black
                                  : Colors.white,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Please enter the details of your payment:",
                      style: theme.textTheme.bodyMedium,
                    ),
                    PrimaryTextField(
                      fieldKey: PaymentDB.referenceKey,
                      controller: PaymentDB.referenceText,
                      label: "Reference Number:",
                      validator: Commons.forcedTextValidator,
                    ),
                    PrimaryTextField(
                      fieldKey: PaymentDB.amountKey,
                      controller: PaymentDB.amountText,
                      label: "Amount:",
                      textInput: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: Commons.forcedTextValidator,
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          print(applicationInfo.userModel.id);
                          paymentDB.updateStudentPayment(
                              context, applicationInfo.userModel.id);
                          await db
                              .collection("student")
                              .doc(applicationInfo.userModel.id)
                              .set({
                            "studentInfo": {
                              "enrolled": true,
                            }
                          }, SetOptions(merge: true));
                        }
                      },
                      label: "Submit",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addPayment(BuildContext context, ApplicationInfo applicationInfo) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final PaymentDB paymentDB = Provider.of<PaymentDB>(context, listen: false);
    // final FirebaseFirestore db = FirebaseFirestore.instance;

    final ThemeData theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enrollment Payment"),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Please choose what category are you in?",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Wrap(
                      spacing: 4.0,
                      children: paymentDB.paymentCategoryList
                          .map((PaymentCategory value) {
                        return PrimaryButton(
                          onPressed: () {
                            setState(() {
                              paymentDB.paymentCategory = value;
                            });
                          },
                          label: value.paymentCategory,
                          color: value.id == paymentDB.paymentCategory?.id
                              ? Colors.white
                              : Colors.black,
                          backgroundColor:
                              value.id == paymentDB.paymentCategory?.id
                                  ? Colors.black
                                  : Colors.white,
                        );
                      }).toList(),
                    ),
                    Text(
                      "Description:",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "${paymentDB.paymentCategory?.paymentCategory}",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Please pay to the following credentials:",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Name: Delmar",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      "Account number: +639684059727",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Image.asset(PngImages.paymentQr),
                    const SizedBox(height: 24.0),
                    const SizedBox(height: 24.0),
                    Text(
                      "Please enter the details of your payment:",
                      style: theme.textTheme.bodyMedium,
                    ),
                    PrimaryTextField(
                      fieldKey: PaymentDB.referenceKey,
                      controller: PaymentDB.referenceText,
                      label: "Reference Number:",
                      validator: Commons.forcedTextValidator,
                    ),
                    PrimaryTextField(
                      fieldKey: PaymentDB.amountKey,
                      controller: PaymentDB.amountText,
                      label: "Amount:",
                      textInput: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: Commons.forcedTextValidator,
                    ),
                    const SizedBox(height: 24.0),
                    PrimaryButton(
                      onPressed: paymentDB.paymentCategory == null &&
                              PaymentDB.amountText.text.isNotEmpty &&
                              PaymentDB.referenceText.text.isNotEmpty
                          ? () async {
                              if (formKey.currentState!.validate()) {
                                paymentDB.updateStudentPayment(
                                    context, applicationInfo.userModel.id);
                              }
                            }
                          : null,
                      label: "Submit",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
