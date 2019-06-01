import 'category.dart';
import 'models.dart';
import 'question.dart';

class Settings {
  String currentTheme;
  ApiType apiType = ApiType.mock;
  int countdown = 8000; // milliseconds
  int numQuestions = 5;
  Category categoryChosen;
  QuestionDifficulty questionsDifficulty = QuestionDifficulty.medium;
}
