import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../styles.dart';
import '../datamodels/trivia_data.dart';
import '../models/models.dart';
import '../models/question.dart';

const questionLeadings = ['A', 'B', 'C', 'D'];
const boxHeight = 72.0;

class AnswersWidget extends StatefulWidget {
  const AnswersWidget(
      {this.triviaModel,
      this.question,
      this.answerAnimation,
      this.isTriviaEnd});

  final Question question;
  final TriviaModel triviaModel;
  final AnswerAnimation answerAnimation;
  final bool isTriviaEnd;

  @override
  _AnswersRebuilder createState() => _AnswersRebuilder();
}

class _AnswersRebuilder extends State<AnswersWidget>
    with TickerProviderStateMixin {
  final Map<int, Animation<double>> animations = {};
  AnimationController controller;
  Animation<Color> colorAnimation;
  Color color;

  bool isCorrect = false;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1250), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _checkCorrectAnswer() {
    // Check if the answer chosen is correct or false
    isCorrect = widget.question.correctAnswerIndex ==
            widget.answerAnimation.chosenAnswerIndex
        ? true
        : false;
  }

  Future _initAnimation() async {
    for (int i = 0; i < 4; i++) {
      animations[i] = Tween<double>(begin: boxHeight * i, end: boxHeight * i)
          .animate(controller);
    }

    colorAnimation = ColorTween(
      begin: answerBoxColor,
      end: answerBoxColor,
    ).animate(controller);
  }

  Future _startAnimation() async {
    _checkCorrectAnswer();

    final index = widget.answerAnimation.chosenAnswerIndex;

    for (int i = 0; i < 4; i++) {
      // Set the animations for the answer but the one chosen
      if (i != index) {
        // From the answer original position to the chosen one
        animations[i] =
            Tween<double>(begin: boxHeight * i, end: boxHeight * index)
                .animate(controller)
                  ..addListener(() {
                    setState(() {});
                    if (controller.status == AnimationStatus.completed) {
                      widget.triviaModel.onChosenAnwserAnimationEnd();
                      controller.reset();
                      isAnimating = false;
                    }
                  });
      }
    }

    var newColor;

    if (isCorrect) {
      newColor = Colors.green;
    } else {
      newColor = Colors.red;
    }

    colorAnimation = ColorTween(
      begin: answerBoxColor,
      end: newColor,
    ).animate(controller);

    await controller.forward();
  }

  Future _playAnimation(String answer) async {
    isAnimating = true;
    widget.triviaModel.onChosenAnswer(answer);
    await _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final widgets = widget.question.answers.map((answer) {
      final index = widget.question.answers.indexOf(answer);

      return Positioned(
        width: MediaQuery.of(context).size.width - 46.0,
        height: 54.0,
        // If the answer isn't the chosen one to the top parameter
        // is passed the value of the animation, while for the chosen
        // answer it is passed a fixed position.
        top: index != widget.answerAnimation.chosenAnswerIndex
            ? animations[index].value
            : boxHeight * index,
        left: 0.0,
        child: GestureDetector(
            child: FadeInWidget(
              duration: 750,
              child: Container(
                decoration: BoxDecoration(
                    color: (index == widget.answerAnimation.chosenAnswerIndex)
                        ? colorAnimation.value
                        : const Color(0xff283593),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color:
                              (colorAnimation.status == AnimationStatus.forward)
                                  ? colorAnimation.value
                                  : Colors.blue[500],
                          blurRadius:
                              (colorAnimation.status == AnimationStatus.forward)
                                  ? 19.0
                                  : 3.0,
                          spreadRadius:
                              (colorAnimation.status == AnimationStatus.forward)
                                  ? 2.5
                                  : 1.5),
                    ]),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: questionCircleAvatarRadius,
                      backgroundColor: questionCircleAvatarBackground,
                      child: Text(
                        questionLeadings[index],
                        style: answersLeadingStyle,
                      )),
                  title: Text(answer, style: answersStyle),
                ),
              ),
            ),
            onTap: () {
              if (!widget.isTriviaEnd && !isAnimating) {
                _playAnimation(answer);
              }
            }),
      );
    }).toList();

    // Swap the last item with the chosen anwser so that it can
    // be shown as the last on the stack.
    final last = widgets.last;
    final chosen = widgets[widget.answerAnimation.chosenAnswerIndex];
    final chosenIndex = widgets.indexOf(chosen);

    widgets.last = chosen;
    widgets[chosenIndex] = last;

    return Container(
      child: Stack(
        children: widgets,
      ),
    );
  }
}
