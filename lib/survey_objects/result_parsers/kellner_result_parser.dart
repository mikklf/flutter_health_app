import 'dart:convert';

/// Parses the JSON result of a [KellnerSurvey]
class KellnerResultParser {
  static Map<String, int> parse(String jsonText) {
  
    var data = jsonDecode(jsonText);

    var answers = data["results"]["kellnerQuestions"]["results"];
    
    // Extract the answer values from the JSON
    Map<int, Object?> answerValues = {};

    answers.forEach((k, v) {
      var answerList = v["results"]["answer"];

      // Sum all values in each answer. Should only contain 1.
      // But we sum just in case.
      var values = [];
      for (var answer in answerList) {
        values.add(answer["value"]);
      }
      var sum = values.reduce((value, element) => value + element);

      // Extract the question id from the key
      var questionId = int.parse(k.replaceAll(RegExp(r'[^0-9]'), ''));
      answerValues[questionId] = sum;
    });
    

    var depressionScaleQuestions = [2, 4, 6, 7, 24, 27, 39, 40, 43, 45, 47, 51, 58, 60, 61, 66, 67, 71, 73, 75, 76, 84, 91];
    // Total score may range from 0 (absence of depression) to 23 (maximum depression).
    var depressionScaleScore = _calculateScore(answerValues, depressionScaleQuestions);

    var depressionSubscaleQuestions = [2, 6, 24, 27, 39, 45, 47, 58, 60, 61, 66, 67, 73, 75, 76, 84, 91];
    // Total score may range from 0 (absence of depression) to 17 (maximum depression).
    var depressionSubscaleScore = _calculateScore(answerValues, depressionSubscaleQuestions);

    var contentmentSubscaleQuestions = [4, 7, 40, 43, 51, 71];
    // Total score may range from 0 (absence of contentment) to 6 (maximum contentment).
    var contentmentSubscaleScore = _calculateScore(answerValues, contentmentSubscaleQuestions);

    return {
      "depressionScaleScore": depressionScaleScore,
      "depressionSubscaleScore": depressionSubscaleScore,
      "contentmentSubscaleScore": contentmentSubscaleScore
    };
  }

  static int _calculateScore(Map<int, dynamic> answers, List<int> questions) {
    // Filter out answers that are not in the questions list
    var answersToQuestion = answers.entries.where((element) => questions.contains(element.key));

    // Sum all values in each answer.
    return answersToQuestion.map((e) => e.value).reduce((value, element) => value + element);
  }

}
