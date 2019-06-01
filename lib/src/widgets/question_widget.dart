import 'package:flutter/material.dart';

import '../datamodels/trivia_data.dart';
import '../models/question.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({this.triviaModel, this.question})
      : assert(question != null);

  final Question question;
  final TriviaModel triviaModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      alignment: Alignment.center,
      height: 18 * 4.0,
      child: Text(
        '${triviaModel.triviaStatus.questionIndex} - ${question.question}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
