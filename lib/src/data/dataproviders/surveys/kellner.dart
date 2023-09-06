import 'package:research_package/research_package.dart';

import 'rp_survey.dart';

class KellnerSurvey implements RPSurvey {
  @override
  String get id => "keller";

  @override
  String get title => "Kellner's Symptom Questionnaire";

  @override
  String get description =>
      "A simple, self-rated assessment of both symptoms and well-being.";

  final List<RPChoice> _yesNo = [
    RPChoice(text: "Yes", value: 1),
    RPChoice(text: "No", value: 0),
  ];

  final List<RPChoice> _trueFalse = [
    RPChoice(text: "True", value: 1),
    RPChoice(text: "False", value: 0),
  ];

  @override
  RPOrderedTask get task =>
      RPNavigableOrderedTask(identifier: "kellner", steps: [
        RPInstructionStep(
          identifier: "kellnerInstruction",
          title: "Instructions",
          detailText: """
For each statement, please press the button corresponding to your answer\n 
For example, when prompted with the word 'Nervous', press the 'Yes' button if you have felt nervous, or the 'No' button if you have not felt nervous.\n 
Similarly, for statements like 'Feeling of not enough air', press the 'TRUE' button if you genuinely experienced that feeling, or the 'FALSE' button if you did not.\n
Don't think much before answering. Thank you.
""",
          text:
              "For the upcoming questions choose the answer closest to how you felt during the past week.",
        ),
        RPFormStep(
            identifier: "kellnerQuestions",
            title: "The Symtom Questionnaire by R. Kellner",
            questions: [
              RPQuestionStep(
                identifier: "kellnerStep1",
                title: "Nervous",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep2",
                title: "Weary",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep3",
                title: "Irritable",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep4",
                title: "Cheerful",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep5",
                title: "Tense, Tensed up",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep6",
                title: "Sad, blue",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep7",
                title: "Happy",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep8",
                title: "Frightened",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep9",
                title: "Feeling calm",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep10",
                title: "Feeling healthy",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep11",
                title: "Losing temper easily",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerStep12",
                title: "Feeling of not enough air",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _trueFalse,
                ),
              ),
            ]),
        RPCompletionStep(
          identifier: "kellnerCompletion",
          title: "Finished",
          text: "Thank you for completing the survey!",
        ),
      ]);
}
