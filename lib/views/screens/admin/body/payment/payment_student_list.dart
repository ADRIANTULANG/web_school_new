import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/extensions/payment_table.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/models/payment.dart';
import 'package:web_school/networks/payment.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar.dart';
import 'package:web_school/views/widgets/body/wrapper/stream.dart';

@RoutePage()
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({
    required this.applicationInfo,
    required this.summaryIndex,
    super.key,
  });

  final ApplicationInfo applicationInfo;
  final int summaryIndex;

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final PaymentDB paymentDB = Provider.of<PaymentDB>(context, listen: false);
      paymentDB.updateStudentPaymentStream(id: paymentDB.paymentId!);
    });
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final applicationInfo = widget.applicationInfo;
    final PaymentDB paymentDB = Provider.of<PaymentDB>(context);


    return Scaffold(
      body: StreamWrapper<List<PaymentDescription>>(
        stream: paymentDB.studentPaymentStream,
        child: (paymentList) {

          final DataTableSource data = PaymentDataList(
            context: context,
            dataList: paymentList!,
          );

          return SafeArea(
            child: AdminNavigationBar(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${applicationInfo.studentInfo.name} Payment/s",
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Divider(
                        color: Colors.black,
                      ),

                       PaginatedDataTable(
                         columns: [
                           DataColumn(label: Text("#")),
                           DataColumn(label: Text("Amount")),
                           DataColumn(label: Text("Date Created")),
                           DataColumn(label: Text("Category")),
                        ],
                          columnSpacing: 0,
                          horizontalMargin: 10,
                          rowsPerPage: 10,
                          source: data,
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
