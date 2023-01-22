import 'package:flutter/material.dart';
import '../constraints.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: text,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: const Text(
        'Question suivante',
        textAlign: TextAlign.center,
      ),
    );
  }
}
