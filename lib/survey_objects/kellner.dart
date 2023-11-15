import 'package:research_package/research_package.dart';

import 'surveys.dart';

class KellnerSurvey implements RPSurvey {
  @override
  String get id => "kellner";

  @override
  String get title => "Kellner's Symptom Questionnaire";

  @override
  String get description =>
      "A simple, self-rated assessment of both symptoms and well-being.";

  @override
  Duration get frequency => const Duration(seconds: 30);

  final List<RPChoice> _yesNo = [
    RPChoice(text: "Yes", value: 1),
    RPChoice(text: "No", value: 0),
  ];

  final List<RPChoice> _noYes = [
    RPChoice(text: "Yes", value: 0),
    RPChoice(text: "No", value: 1),
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
                identifier: "kellnerItem2",
                title: "Weary",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem4",
                title: "Cheerful",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _noYes,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem6",
                title: "Sad, blue",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem7",
                title: "Happy",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _noYes,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem24",
                title: "Feeling unworthy",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem27",
                title: "Cannot enjoy yourself",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _trueFalse,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem39",
                title: "Feeling guilty",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem40",
                title: "Feeling well",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _noYes,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem43",
                title: "Contented",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _noYes,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem45",
                title: "Feeling desperate, terrible",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem47",
                title: "Thinking of death or dying",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem51",
                title: "Enjoying yourself",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _noYes,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem58",
                title: "Depressed",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem60",
                title: "Feeling a failure",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem61",
                title: "Not interested in things",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _trueFalse,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem66",
                title: "Blaming yourself",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem67",
                title: "Thoughts of ending your life",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem71",
                title: "Looking forward toward the future",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _noYes,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem73",
                title: "Feeling that life is bad",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem75",
                title: "Feeling inferior to others",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem76",
                title: "Feeling useless",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem84",
                title: "Feel like crying",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
                ),
              ),
              RPQuestionStep(
                identifier: "kellnerItem91",
                title: "Feeling of hopelesness",
                answerFormat: RPChoiceAnswerFormat(
                  answerStyle: RPChoiceAnswerStyle.SingleChoice,
                  choices: _yesNo,
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
