import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/views/widgets/tiles/grey.dart';

class StudentsPayment extends StatelessWidget {
  const StudentsPayment({
    required this.studentList,
    required this.paymentList,
    super.key,
  });

  final List<ApplicationInfo> studentList;
  final List<Payment> paymentList;

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.pushRoute(
          SummaryPaymentRoute(
              applicationInfo: studentList,
              paymentList: paymentList
          ),
        );
      },
      child: GreyTile(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Payment",
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Summary payment",
              style: theme.textTheme.bodyMedium!.copyWith(),
            ),
            const SizedBox(height: 50.0),
            LinearPercentIndicator(
                percent: paymentList.length / 100,
                barRadius: const Radius.circular(12),
                lineHeight: 12,
                progressColor: ColorTheme.primaryRed,
                backgroundColor: ColorTheme.primaryBlack
            ),
          ],
        ),
      ),
    );
  }
}
