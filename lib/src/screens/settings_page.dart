import 'package:flutter/material.dart';

import 'package:rebuilder/rebuilder.dart';

import '../datamodels/app_data.dart';
import '../models/models.dart';
import '../models/question.dart';
import '../models/theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final countdownController = TextEditingController();
  final amountController = TextEditingController();

  String errorAmount = '', errorTime = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settings =
        DataModelProvider.of<AppModel>(context).settingsModel.settings;

    countdownController.text = (settings.countdown ~/ 1000).toInt().toString();

    amountController.text = settings.numQuestions.toString();
  }

  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Settings',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => appModel.tab.value = AppTab.main,
          )),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Choose a theme:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
               /* DropdownButton<MyTheme>(
                  hint: const Text('Status'),
                  value: appModel.settingsModel.settings.currentTheme,
                  items: _buildThemesList(),
                  onChanged: appModel.settingsModel.setTheme,
                ),*/
                DropdownButton<String>(
                  value: appModel.settingsModel.settings.currentTheme,
                  items: [
                    for (var theme in themes.keys)
                      DropdownMenuItem<String>(
                        value: theme,
                        child:
                            Text(theme, style: const TextStyle(fontSize: 14.0)),
                      )
                  ],
                  onChanged: appModel.settingsModel.setTheme,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Quiz database:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                DropdownButton<ApiType>(
                    value: appModel.settingsModel.settings.apiType,
                    onChanged: appModel.settingsModel.setApiType,
                    items: [
                      const DropdownMenuItem<ApiType>(
                        value: ApiType.mock,
                        child: Text('Demo'),
                      ),
                      const DropdownMenuItem<ApiType>(
                        value: ApiType.remote,
                        child: Text('opentdb.com'),
                      ),
                    ]),
              ],
            ),
            appModel.settingsModel.settings.apiType == ApiType.mock
                ? Container()
                : Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'N. of questions:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  final amount = int.tryParse(value);
                                  if (amount <= 1 || amount > 15) {
                                    setState(() {
                                      errorAmount =
                                          'Insert a value from 2 to 15.';
                                    });
                                  } else {
                                    setState(() {
                                      errorAmount = '';
                                      appModel.settingsModel.settings
                                          .numQuestions = int.parse(value);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errorAmount = 'Insert a value.';
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter a value between 2 and 15.',
                                  errorText: errorAmount.isNotEmpty
                                      ? errorAmount
                                      : null),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Difficulty:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          DropdownButton<QuestionDifficulty>(
                              value: appModel
                                  .settingsModel.settings.questionsDifficulty,
                              onChanged: appModel.settingsModel.setDifficulty,
                              items: [
                                const DropdownMenuItem<QuestionDifficulty>(
                                  value: QuestionDifficulty.easy,
                                  child: Text('Easy'),
                                ),
                                const DropdownMenuItem<QuestionDifficulty>(
                                  value: QuestionDifficulty.medium,
                                  child: Text('Medium'),
                                ),
                                const DropdownMenuItem<QuestionDifficulty>(
                                  value: QuestionDifficulty.hard,
                                  child: Text('Hard'),
                                ),
                              ]),
                        ],
                      ),
                    ],
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Countdown:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: countdownController,
                    onSubmitted: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          errorTime = 'Please enter some text';
                        });
                      } else {
                        final time = int.tryParse(value);
                        if (time < 3 || time > 90) {
                          setState(() {
                            errorTime = 'Insert a value from 3 to 90 seconds.';
                          });
                        } else {
                          setState(() {
                            errorTime = '';
                            appModel.settingsModel.settings.countdown =
                                int.parse(value) * 1000;
                          });
                        }
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a value in seconds (max 60).',
                      errorText: errorTime.isNotEmpty ? errorTime : null,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
