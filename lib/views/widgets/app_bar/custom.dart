import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_school/networks/auth.dart';
import 'package:web_school/values/strings/colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    // final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    final Auth auth = Provider.of<Auth>(context);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: ColorTheme.primaryRed,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 4,
          )
        ]
      ),
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => auth.logout(context),
          child: Text("Logout",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
