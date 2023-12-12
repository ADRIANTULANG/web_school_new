import 'package:flutter/material.dart';

class GreyTile extends StatelessWidget {
  const GreyTile({
    required this.child,
    this.backgroundColor,
    this.width = double.infinity,
    this.boxShadow,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final double width;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12.0,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: backgroundColor ?? Colors.grey.withOpacity(0.1),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
