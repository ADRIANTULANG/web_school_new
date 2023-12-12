import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class OnHoverListTileButton extends StatefulWidget {
  const OnHoverListTileButton({
    required this.onTap,
    this.leading,
    required this.title,
    this.backgroundColor,
    super.key,
  });

  final Function() onTap;
  final Widget? leading;
  final Widget title;
  final Color? backgroundColor;

  @override
  State<OnHoverListTileButton> createState() => _OnHoverListTileButtonState();
}

class _OnHoverListTileButtonState extends State<OnHoverListTileButton> {

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity();
      // ..translate(8, 0, 0);
    final transform = isHovered ? hoveredTransform : Matrix4.identity();

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          duration: const Duration(milliseconds: 500),
          curve: Sprung.overDamped,
          transform: transform,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: widget.backgroundColor ?? (isHovered ? Colors.redAccent : Colors.transparent),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.leading ?? SizedBox(),
              ),
              const SizedBox(width: 8.0),
              widget.title,
            ],
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
