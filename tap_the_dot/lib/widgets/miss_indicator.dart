import 'package:flutter/material.dart';

class MissIndicator extends StatefulWidget {
  const MissIndicator({super.key});
  @override
  State<MissIndicator> createState() => _MissIndicatorState();
}

class _MissIndicatorState extends State<MissIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(_controller),
      child: const Text('Miss!', 
        style: TextStyle(
          fontSize: 42, 
          color: Colors.red, 
          fontWeight: FontWeight.bold, 
          shadows: [Shadow(color: Colors.black, blurRadius: 8)]
        )
      ),
    );
  }
}