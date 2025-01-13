import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key, 
    required this.child, 
    required this.label, 
    this.color = Colors.yellow
  });

  final Widget child;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10
              ),
            ),
          ))
      ],
    );
  }
}