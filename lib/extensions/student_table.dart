import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/views/widgets/hover/text.dart';

class StudentDataList extends DataTableSource {
  StudentDataList({
    required this.context,
    required this.dataList,
  });

  final List<ApplicationInfo> dataList;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);

    final firstName = dataList[index].personalInfo.firstName;
    final lastName = dataList[index].personalInfo.lastName;
    final middleInitial = dataList[index].personalInfo.middleName;
    // final password = dataList[index].userModel.password;

    final controlNumber = dataList[index].userModel.controlNumber;
    final grade = dataList[index].schoolInfo.gradeToEnroll;

    final id = dataList[index].userModel.id;

    return DataRow(cells: [
      DataCell(
        Text(
          "$lastName, $firstName $middleInitial.",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          softWrap: true,
        ),
      ),
      DataCell(
        OnHoverTextButton(
          onTap: () {
            adminDB.updateStudentId(id);
            context.pushRoute(AdminStudentProfileRoute());
          },
          label: controlNumber,
        ),
      ),
      // DataCell(Text("${password}",
      //     style: TextStyle(
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      // ),
      DataCell(
        Text(
          "${grade.label}",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      DataCell(
        IconButton(
          onPressed: () {
            print("delete");
            adminDB.deleteStudent(context, id);
          },
          icon: Icon(
            CupertinoIcons.trash,
            color: Colors.red,
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount => 0;
}
