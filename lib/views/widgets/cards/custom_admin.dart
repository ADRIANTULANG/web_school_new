import 'package:flutter/material.dart';

class CustomAdminCard extends StatelessWidget {
  const CustomAdminCard({
    required this.onTap,
    required this.imageIcon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.titleSize,
    this.subtitleSize,
    super.key,
  });
  
  final Function() onTap;
  final String imageIcon;
  final String title;
  final String subtitle;
  final Color color;
  final double? titleSize;
  final double? subtitleSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          hoverColor: Colors.white24,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox.square(
                    dimension: size.width * 0.09,
                    child: Image.asset(
                      imageIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(title,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: titleSize ?? size.width * 0.014,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(subtitle,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: subtitleSize ?? size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
