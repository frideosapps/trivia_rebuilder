import '../../models/category.dart';
import '../../models/question.dart';

abstract class QuestionsAPI {
  Future<List<Category>> getCategories();
  Future<List<Question>> getQuestions(
      {int number,
      Category category,
      QuestionDifficulty difficulty,
      QuestionType type});
}
