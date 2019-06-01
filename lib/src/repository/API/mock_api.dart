import 'dart:async';

import 'dart:convert' as convert;

import '../../models/category.dart';
import '../../models/question.dart';

import 'api_interface.dart';

class MockAPI implements QuestionsAPI {
  @override
  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    categories.addAll([
      Category(id: 1, name: 'Category demo'),
      Category(id: 2, name: 'Category demo2'),
      Category(id: 3, name: 'Category demo3'),
    ]);
    print(categories);
    return categories;
  }

  @override
  Future<List<Question>> getQuestions(
      {List<Question> questions,
      int number,
      Category category,
      QuestionDifficulty difficulty,
      QuestionType type}) async {
    const json =
        "{\"response_code\":0,\"results\":[{\"category\":\"General Knowledge\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"What is the largest organ of the human body?\",\"correct_answer\":\"Skin\",\"incorrect_answers\":[\"Heart\",\"large Intestine\",\"Liver\"]},{\"category\":\"Science: Mathematics\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"In Roman Numerals, what does XL equate to?\",\"correct_answer\":\"40\",\"incorrect_answers\":[\"60\",\"15\",\"90\"]},{\"category\":\"Entertainment: Television\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"Grant Gustin plays which superhero on the CW show of the same name?\",\"correct_answer\":\"The Flash\",\"incorrect_answers\":[\"The Arrow\",\"Black Canary\",\"Daredevil\"]},{\"category\":\"Entertainment: Cartoon & Animations\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"In the 1993 Disney animated series, what is the name of Bonker\'s second partner?\",\"correct_answer\":\"Miranda Wright\",\"incorrect_answers\":[\"Dick Tracy\",\"Eddie Valiant\",\"Dr. Ludwig von Drake\"]},{\"category\":\"Geography\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"How many countries does Mexico border?\",\"correct_answer\":\"3\",\"incorrect_answers\":[\"2\",\"4\",\"1\"]}]}";

    final jsonResponse = convert.jsonDecode(json);

    final result = (jsonResponse['results'] as List)
        .map((question) => QuestionModel.fromJson(question));

    questions =
        result.map((question) => Question.fromQuestionModel(question)).toList();
    print(questions);
    return questions;
  }
}
