import 'package:flutter/material.dart';
// import 'package:web_school/values/strings/colors.dart';

class OnHoverTextButton extends StatefulWidget {
  const OnHoverTextButton({
    required this.label,
    this.fontSize = 14,
    required this.onTap,
    super.key,
  });

  final String label;
  final double fontSize;
  final Function() onTap;

  @override
  State<OnHoverTextButton> createState() => _OnHoverTextButtonState();
}

class _OnHoverTextButtonState extends State<OnHoverTextButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity();
    final transform = isHovered ? hoveredTransform : Matrix4.identity();

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          transform: transform,
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: widget.fontSize,
              fontWeight: isHovered ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
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
