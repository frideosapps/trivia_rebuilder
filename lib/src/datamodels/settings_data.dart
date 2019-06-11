import 'dart:async';

import 'package:frideos/frideos.dart';
import 'package:rebuilder/rebuilder.dart';

import '../models/category.dart';
import '../models/models.dart';
import '../models/question.dart';
import '../models/settings.dart';
import '../models/states.dart';
import '../models/theme.dart';
import '../repository/repository.dart';

class SettingsModel extends DataModel {
  SettingsModel({this.states, this.repository});

  final States states;

  final Repository repository;

  final settings = Settings();

  Future<bool> loadTheme() async {
    final String lastTheme = await Prefs.getPref('apptheme');
    if (lastTheme != null) {
      settings.currentTheme =
          themes.containsKey(lastTheme) ? lastTheme : 'Dark';
    }
    return true;
  }

  void setCategory(Category category) {
    settings.categoryChosen = category;
    states.mainPage.rebuild();
  }

  void setDifficulty(QuestionDifficulty difficulty) {
    settings.questionsDifficulty = difficulty;
    states.settingsPage.rebuild();
  }

  void setApiType(ApiType type) {
    if (settings.apiType != type) {
      settings.apiType = type;
      repository
        ..needCategoriesLoading = true
        ..changeApi(type);
    }
    states.tab.rebuild();
  }

  void setTheme(String theme) {
    settings.currentTheme = theme;
    states.materialPage.rebuild();
    Prefs.savePref<String>('apptheme', theme);
  }

  @override
  void dispose() {}
}
