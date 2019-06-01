import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import 'package:rebuilder/rebuilder.dart';

import '../datamodels/app_data.dart';
import '../models/category.dart';
import '../models/models.dart';
import '../models/settings.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);
    print('MAINPAGE REBUILDING');

    return FadeInWidget(
      duration: 750,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Rebuilder<List<Category>>(
          dataModel: appModel.repository.categories,
          rebuilderState: appModel.states.categories,
          builder: (state, dataCategories) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 56.0),
                      child: const Text(
                        'TRIVIA',
                        style: TextStyle(
                          fontSize: 46.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.lightBlueAccent,
                              offset: Offset(3.0, 4.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Choose a category:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 14.0,
                            color: Colors.lightBlueAccent,
                          ),
                        ],
                      ),
                    ),
                    Rebuilder<Settings>(
                      dataModel: appModel.settingsModel.settings,
                      rebuilderState: appModel.states.mainPage,
                      builder: (state, dataSettings) =>
                          DropdownButton<Category>(
                            isExpanded: true,
                            value: dataSettings.categoryChosen,
                            onChanged: appModel.settingsModel.setCategory,
                            items: dataCategories
                                .map<DropdownMenuItem<Category>>(
                                  (value) => DropdownMenuItem<Category>(
                                        value: value,
                                        child: Text(
                                          value.name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                )
                                .toList(),
                          ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: 36,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(35),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue,
                              blurRadius: 2.0,
                              spreadRadius: 2.5),
                        ]),
                    child: const Text(
                      'Play trivia',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  onTap: () => appModel.tab.value = AppTab.trivia,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
