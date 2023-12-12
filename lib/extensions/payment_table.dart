import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_school/models/payment.dart';

class PaymentDataList extends DataTableSource {
  PaymentDataList({
    required this.context,
    required this.dataList,
  });

  final List<PaymentDescription> dataList;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    // final ThemeData theme = Theme.of(context);
    // final PaymentDB paymentDB = Provider.of<PaymentDB>(context);

    final amount = dataList[index].amount;
    final refNumber = dataList[index].refNumber;
    // final status = dataList[index].status;
    final dateCreated = dataList[index].dateTime;
    final category = dataList[index].paymentCategory.paymentCategory;

    final dateFormatted =
        DateFormat("MMMM-dd-yyyy").format(dateCreated.toDate());

    // final isAccepted = status.toLowerCase() == "accept";
    // final isRejected = status.toLowerCase() == "reject";
    // final isPending = status.toLowerCase() == "pending";

    return DataRow(cells: [
      DataCell(
        Text(
          "$refNumber",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          softWrap: true,
        ),
      ),
      DataCell(
        Text(
          "$amount",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          softWrap: true,
        ),
      ),
      DataCell(
        Text(
          "$dateFormatted",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      DataCell(
        Text(
          "$category",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // DataCell(
      //   Row(
      //     children: [
      //       OnHoverButton(
      //         onTap: () {},
      //         builder: (isHovered) => Text("Accept",
      //           style: theme.textTheme.bodyMedium!.copyWith(
      //             color: isHovered ? Colors.white : Colors.black87
      //           ),
      //         ),
      //       ),
      //       OnHoverButton(
      //         backgroundColor: isRejected || !isPending
      //             ? ColorTheme.primaryRed
      //             : null,
      //         onTap: () {
      //
      //         },
      //         builder: (isHovered) => Text(status.toLowerCase() == "reject"
      //             ? "Rejected"
      //             : "Reject",
      //           style: theme.textTheme.bodyMedium!.copyWith(
      //               color: isHovered ? Colors.white : Colors.black87
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount => 0;
}
