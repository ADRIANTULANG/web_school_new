import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/router/routes.gr.dart';
import 'package:web_school/views/widgets/hover/text.dart';

class InstructorDataList extends DataTableSource {
  InstructorDataList({
    required this.context,
    required this.dataList,
  });

  final List<Instructor> dataList;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    final AdminDB adminDB = Provider.of<AdminDB>(context, listen: false);

    final username = dataList[index].username;

    final grade = dataList[index].grade;
    final section = dataList[index].section;
    final id = dataList[index].userModel.id;

    return DataRow(cells: [
      DataCell(
        OnHoverTextButton(
          label: username,
          onTap: () {
            adminDB.updateInstructorId(id);
            context.pushRoute(
              AdminEditInstructorRoute(
                instructorData: dataList[index],
              ),
            );
          },
        ),
      ),
      DataCell(
        Text(
          "${grade?.label}",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      DataCell(
        Text(
          "${section?.label}",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            adminDB.deleteInstructor(context, id);
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
