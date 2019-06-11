import 'dart:async';

import 'package:rebuilder/rebuilder.dart';

import '../models/models.dart';
import '../models/question.dart';
import '../models/settings.dart';
import '../models/states.dart';
import '../models/trivia_stats.dart';
import '../repository/repository.dart';

const refreshTime = 20;

class TriviaModel extends DataModel {
  TriviaModel({
    this.states,
    this.tab,
    this.settings,
    this.repository,
  });

  final States states;
  final RebuilderObject<AppTab> tab;
  final Settings settings;
  final Repository repository;

  final TriviaStatus triviaStatus = TriviaStatus();
  final triviaStats = TriviaStats();
  final AnswerAnimation answersAnimation =
      AnswerAnimation(chosenAnswerIndex: 0, startPlaying: false);

  int index = 0;
  Question currentQuestion;
  String chosenAnswer;
  int currentTime = 0;
  double countdownBar;
  Timer timer;

  void setupTrivia(List<Question> data) {
    assert(data.length > 0, 'QUESTIONS NULL');

    // Reset
    index = 0;
    triviaStatus.questionIndex = 1;
    triviaStats.reset();

    // To set the initial question (in this case the countdown
    // bar animation won't start).
    currentQuestion = data.first;
    // To show the main page and summary buttons
    triviaStatus.isTriviaEnd = false;

    Timer(Duration(milliseconds: 1500), () {
      // Setting this flag to true on changing the question
      // the countdown bar animation starts.
      triviaStatus.isTriviaPlaying = true;

      // Show again the first question with the countdown bar
      // animation.
      currentQuestion = data[index];

      playTrivia();
    });
  }

  void playTrivia() {
    states.triviaPage.rebuild();
    timer = Timer.periodic(Duration(milliseconds: refreshTime), (t) {
      currentTime = refreshTime * t.tick;

      if (currentTime > settings.countdown) {
        currentTime = 0;
        timer.cancel();
        notAnswered(currentQuestion);
        _nextQuestion();
      }
    });
  }

  void _endTrivia() {
    // RESET
    timer.cancel();
    currentTime = 0;
    triviaStatus.isTriviaEnd = true;

    states.triviaPage.rebuild();
    stopTimer();

    Timer(Duration(milliseconds: 1500), () {
      // this is reset here to not trigger the start of the
      // countdown animation while waiting for the summary page.
      triviaStatus.isAnswerChosen = false;
      // Show the summary page after 1.5s
      tab.value = AppTab.summary;

      // Clear the last question so that it doesn't appear
      // in the next game
      currentQuestion = null;
    });
  }

  void notAnswered(Question question) => triviaStats.addNoAnswer(question);

  void checkAnswer(Question question, String answer) {
    if (!triviaStatus.isTriviaEnd) {
      question.chosenAnswerIndex = question.answers.indexOf(answer);
      if (question.isCorrect(answer)) {
        triviaStats.addCorrect(question);
      } else {
        triviaStats.addWrong(question);
      }

      timer.cancel();
      currentTime = 0;

      _nextQuestion();
    }
  }

  void _nextQuestion() {
    index++;

    if (index < settings.numQuestions) {
      triviaStatus.questionIndex++;
      currentQuestion = repository.questions[index];
      playTrivia();
    } else {
      _endTrivia();
    }
  }

  void stopTimer() {
    // Stop the timer
    timer.cancel();
    // By setting this flag to true the countdown animation will stop
    triviaStatus.isAnswerChosen = true;
    states.triviaPage.rebuild();
  }

  void onChosenAnswer(String answer) {
    chosenAnswer = answer;

    stopTimer();

    // Set the chosenAnswer so that the answer widget can put it last on the
    // stack.
    answersAnimation.chosenAnswerIndex =
        currentQuestion.answers.indexOf(answer);
    states.triviaPage.rebuild();
  }

  void onChosenAnwserAnimationEnd() {
    // Reset the flag so that the countdown animation can start
    triviaStatus.isAnswerChosen = false;
    states.triviaPage.rebuild();

    checkAnswer(currentQuestion, chosenAnswer);
  }

  @override
  void dispose() {}
}
