import 'package:flutter/material.dart';

import 'package:rebuilder/rebuilder.dart';

import 'src/homepage.dart';
import 'src/datamodels/app_data.dart';
import 'src/models/settings.dart';
import 'src/models/theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: appModel.settingsModel.loadTheme(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : DataModelProvider<AppModel>(
                  dataModel: appModel,
                  child: MaterialPage(),
                );
        });
  }
}

class MaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);

    return Rebuilder<Settings>(
        dataModel: appModel.settingsModel.settings,
        rebuilderState: appModel.states.materialPage,
        builder: (state, data) {
          // To rebuild the widget tree, use the materialState
          return MaterialApp(
              title: 'Trivia example',
              theme: themes[data.currentTheme],
              home: HomePage());
        });
  }
}
