import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final Color color;
  final double radius;
  final VoidCallback onTap;

  const DotWidget({
    super.key,
    required this.color,
    required this.radius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 16,
              spreadRadius: 2,
            )
          ],
        ),
      ),
    );
  }
}