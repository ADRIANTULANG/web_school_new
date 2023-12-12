import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';
import 'package:web_school/values/strings/colors.dart';

class OnHoverButton extends StatefulWidget {
  const OnHoverButton({
    required this.builder,
    required this.onTap,
    this.backgroundColor,
    super.key,
  });

  final Widget Function(bool isHovered) builder;
  final Function() onTap;
  final Color? backgroundColor;

  @override
  State<OnHoverButton> createState() => _OnHoverButtonState();
}

class _OnHoverButtonState extends State<OnHoverButton> {

  bool isHovered = false;


  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()
      ..translate(8, 0, 0);
    final transform = isHovered ? hoveredTransform : Matrix4.identity();

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          duration: const Duration(seconds: 1),
          curve: Sprung.overDamped,
          transform: transform,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isHovered ? 16.0 : 12.0),
            border: Border.all(
              color:  ColorTheme.primaryRed,
            ),
            color: widget.backgroundColor ?? (isHovered ? ColorTheme.primaryRed : Colors.white),
          ),
          child: widget.builder(isHovered),
        ),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
