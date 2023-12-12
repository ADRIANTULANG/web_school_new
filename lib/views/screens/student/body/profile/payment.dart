import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/payment.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';
import 'package:web_school/views/widgets/dialogs/custom.dart';

@RoutePage()
class StudentPaymentHomeScreen extends StatefulWidget {
  const StudentPaymentHomeScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentPaymentHomeScreen> createState() => _StudentPaymentHomeScreenState();
}

class _StudentPaymentHomeScreenState extends State<StudentPaymentHomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final PaymentDB paymentDB = Provider.of<PaymentDB>(context, listen: false);
      paymentDB.updateStudentPaymentStream(id: widget.applicationInfo.userModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {

    final PaymentDB paymentDB = Provider.of<PaymentDB>(context);
    final ThemeData theme = Theme.of(context);

    final CustomDialog customDialog = CustomDialog();

    return StreamWrapper<List<PaymentDescription>>(
      stream: paymentDB.studentPaymentStream,
      child: (paymentList) {

        return paymentList!.isEmpty
            ? Center(
          child: Text("You still have no history of payment"),
        )
            : SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Payment History",
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Divider(
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PrimaryButton(
                      onPressed: () {
                        customDialog.addPayment(context,
                          widget.applicationInfo,
                        );
                      },
                      label: "Add Payment",
                    ),
                  ),
                  // Text("Your current balance is: ${widget.applicationInfo.studentInfo.balance}"),
                  const SizedBox(height: 24.0),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {

                      final payment = paymentList[index];
                      final date = payment.dateTime.toDate();

                      final formattedDate = DateFormat("MMMM dd, yyyy").format(date);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: ColorTheme.primaryYellow,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.money),
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(width: 4.0),
                                Text("Ref number: ${payment.refNumber}",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Status: ${payment.status}"),
                                  Text("Amount: ₱${payment.amount}"),
                                  Text("Date transaction: ${formattedDate}"),
                                  Text("Category: ${payment.paymentCategory.paymentCategory}"),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
