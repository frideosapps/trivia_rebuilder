import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import 'package:rebuilder/rebuilder.dart';

import '../datamodels/app_data.dart';
import '../models/models.dart';
import '../models/trivia_stats.dart';
import '../widgets/summaryanswer_widget.dart';
import '../styles.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({this.triviaStats});

  final TriviaStats triviaStats;

  List<Widget> _buildQuestions() {
    var index = 0;

    final widgets = List<Widget>()
      ..add(
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Text(
            'Final score: ${triviaStats.score}',
            style: summaryScoreStyle,
          ),
        ),
      );

    if (triviaStats.corrects.isNotEmpty) {
      widgets
        ..add(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 32,
            color: Colors.indigo[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'CORRECTS: ${triviaStats.corrects.length}',
                  style: correctsHeaderStyle,
                ),
              ],
            ),
          ),
        )
        ..addAll(
          triviaStats.corrects.map((question) {
            index++;
            return SummaryAnswers(
              index: index,
              question: question,
            );
          }),
        );
    }

    if (triviaStats.wrongs.isNotEmpty) {
      widgets
        ..add(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 32,
            color: Colors.indigo[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'WRONGS: ${triviaStats.wrongs.length}',
                  style: wrongsHeaderStyle,
                ),
              ],
            ),
          ),
        )
        ..addAll(
          triviaStats.wrongs.map((question) {
            index++;
            return SummaryAnswers(
              index: index,
              question: question,
            );
          }),
        );
    }

    if (triviaStats.noAnswered.isNotEmpty) {
      widgets
        ..add(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 32,
            color: Colors.indigo[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'NOT GIVEN: ${triviaStats.noAnswered.length}',
                  style: notAnsweredHeaderStyle,
                ),
              ],
            ),
          ),
        )
        ..addAll(
          triviaStats.noAnswered.map((question) {
            index++;
            return SummaryAnswers(
              index: index,
              question: question,
            );
          }),
        );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    return FadeInWidget(
      duration: 750,
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            ..._buildQuestions(),
            Container(height: 24),
            Container(
              width: 90,
              child: RaisedButton(
                child: const Text('Home'),
                onPressed: () => appModel.tab.value = AppTab.main,
              ),
            )
          ],
        ),
      ),
    );
  }
}
