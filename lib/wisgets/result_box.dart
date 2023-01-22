import 'package:flutter/material.dart';
import '../constraints.dart';

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key,
      required this.result,
      required this.questionLength,
      required this.onPressed});
  final int result;
  final int questionLength;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: neutral,
      content: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Resultat',
              style: TextStyle(color: text, fontSize: 22.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              radius: 70.0,
              backgroundColor: result == questionLength
                  ? correct
                  : result < questionLength / 2
                      ? incorrect
                      : neutral,
              child: Text(
                '$result/$questionLength',
                style: const TextStyle(fontSize: 30.0),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              result == questionLength
                  ? 'Excelent !! ACE'
                  : result < questionLength / 2
                      ? 'pas assez bien'
                      : 'tres biens ',
              style: const TextStyle(color: text),
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
                onTap: onPressed,
                child: const Text(
                  'Recommencer',
                  style: TextStyle(
                    color: correct,
                    fontSize: 15.0,
                    letterSpacing: 1.0,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
