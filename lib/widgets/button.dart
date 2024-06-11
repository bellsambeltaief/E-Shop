import 'package:flutter/material.dart';

/// Les boutons du l'application
class Button extends StatelessWidget {
  final String label;
  final void Function() onTap;
  const Button({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
        label,
        style: const TextStyle(
        color: Colors.white,
        ),
        ),
      ),
    );
  }
}
