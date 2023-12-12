import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/payment.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/values/strings/colors.dart';

@RoutePage()
class SummaryPaymentScreen extends StatefulWidget {
  const SummaryPaymentScreen({
    required this.applicationInfo,
    required this.paymentList,
    super.key,
  });

  final List<ApplicationInfo> applicationInfo;
  final List<Payment> paymentList;

  @override
  State<SummaryPaymentScreen> createState() => _SummaryPaymentScreenState();
}

class _SummaryPaymentScreenState extends State<SummaryPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final paymentList = widget.paymentList;
    final applicationInfo = widget.applicationInfo;
    final PaymentDB paymentDB = Provider.of<PaymentDB>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Payment List",
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12.0),
            Divider(
              color: Colors.black,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: paymentList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      context.pushRoute(PaymentHistoryRoute(
                        applicationInfo: applicationInfo[index],
                        summaryIndex: index,
                      ));
                      paymentDB.updatePaymentId(paymentList[index].id);
                      print(paymentDB.paymentId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorTheme.primaryRed,
                                child: Text(
                                  "${index + 1}",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(applicationInfo[index].studentInfo.name),
                                  Text(
                                      "${applicationInfo[index].schoolInfo.gradeToEnroll.label}"),
                                ],
                              ),
                            ],
                          ),
                          Icon(CupertinoIcons.arrow_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
