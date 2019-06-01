import 'category.dart';
import 'question.dart';
import 'theme.dart';

enum AppTab { main, trivia, summary, triviaStats, settings }

enum ApiType { mock, remote }

class TriviaStatus {
  bool isTriviaPlaying = false;
  bool isTriviaEnd = false;
  bool isAnswerChosen = false;
  int questionIndex = 1;
}

class AnswerAnimation {
  AnswerAnimation({this.chosenAnswerIndex, this.startPlaying});

  int chosenAnswerIndex;
  bool startPlaying = false;
}

