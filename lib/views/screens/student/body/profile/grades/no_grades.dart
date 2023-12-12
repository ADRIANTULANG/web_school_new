import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/student.dart';
import 'package:web_school/views/widgets/hover/text.dart';

class NotEnrolledScreen extends StatelessWidget {
  const NotEnrolledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StudentDB studentDB = Provider.of<StudentDB>(context);

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 24.0),
          Text(
            "You are currently not enrolled.",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4.0),
          const Text(
            "Please enroll first to see your grades",
          ),
          const SizedBox(height: 24.0),
          OnHoverTextButton(
            label: "Click here to enroll",
            onTap: () => studentDB.updateStudentIndex(2),
          ),
        ],
      ),
    );
  }
}
