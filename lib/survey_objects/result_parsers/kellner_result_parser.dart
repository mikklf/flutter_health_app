import 'dart:convert';

/// Parses the JSON result of a [KellnerSurvey]
class KellnerResultParser {
  static Map<String, int> parse(String jsonText) {
  
    var data = jsonDecode(jsonText);

    var answers = data["results"]["kellnerQuestions"]["results"];
    
    // Extract the answer values from the JSON
    Map<int, int> answerValues = {};

    answers.forEach((k, v) {
      var answerList = v["results"]["answer"];

      // Sum all values in each answer. Should only contain 1.
      // But we sum just in case.
      var values = [];
      for (var answer in answerList) {
        values.add(answer["value"]);
      }
      int sum = values.reduce((value, element) => value + element);

      // Extract the question id from the key
      int questionId = int.parse(k.replaceAll(RegExp(r'[^0-9]'), ''));
      answerValues[questionId] = sum;
    });
    

    var depressionScaleNormalQuestions = [2, 6, 24, 27, 39, 45, 47, 58, 60, 61, 66, 67, 73, 75, 76, 84, 91];
    var depressionScaleReverseQuestions = [4, 7, 40, 43, 51, 71];
    // Total score may range from 0 (absence of depression) to 23 (maximum depression).
    var depressionScaleScore = _calculateScore(answerValues, depressionScaleNormalQuestions, depressionScaleReverseQuestions);

    var depressionSubscaleQuestions = [2, 6, 24, 27, 39, 45, 47, 58, 60, 61, 66, 67, 73, 75, 76, 84, 91];
    // Total score may range from 0 (absence of depression) to 17 (maximum depression).
    var depressionSubscaleScore = _calculateScore(answerValues, depressionSubscaleQuestions, []);

    var contentmentSubscaleQuestions = [4, 7, 40, 43, 51, 71];
    // Total score may range from 0 (absence of contentment) to 6 (maximum contentment).
    var contentmentSubscaleScore = _calculateScore(answerValues, contentmentSubscaleQuestions, []);

    return {
      "depressionScaleScore": depressionScaleScore,
      "depressionSubscaleScore": depressionSubscaleScore,
      "contentmentSubscaleScore": contentmentSubscaleScore
    };
  }

  static int _calculateScore(Map<int, int> answers, List<int> normalScoreQuestions, List<int> reverseScoreQuestions) {

    // Calculate score based on weather the question is a normal or reverse score question
    int score = 0;
    answers.forEach((questionId, value) {
      if (normalScoreQuestions.contains(questionId)) {
        score += value;
      } else if (reverseScoreQuestions.contains(questionId)) {
        score += value == 1 ? 0 : 1;
      }
    });
    return score;

  }

}
