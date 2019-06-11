import 'package:rebuilder/rebuilder.dart';

import 'settings_data.dart';
import 'trivia_data.dart';
import '../models/models.dart';
import '../models/states.dart';
import '../repository/repository.dart';

class AppModel extends DataModel {
  factory AppModel() => _singletonAppModel;

  AppModel._internal() {
    print('-------APP STATE INIT--------');

    settingsModel = SettingsModel(states: states, repository: repository);

    tab = RebuilderObject<AppTab>.init(
        rebuilderState: states.tab,
        initialData: AppTab.main,
        onChange: () => print('changedTab ${tab.value}'));

    triviaModel = TriviaModel(
        states: states,
        settings: settingsModel.settings,
        repository: repository,
        tab: tab);
  }

  static final AppModel _singletonAppModel = AppModel._internal();

  final repository = Repository();

  final states = States();

  // DATA MODELS
  TriviaModel triviaModel;
  SettingsModel settingsModel;

  // Used to change the tab whenever a new tab is assigned to it.
  RebuilderObject<AppTab> tab;

  @override
  void dispose() {}
}
