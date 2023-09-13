import 'package:research_package/research_package.dart';

import 'surveys.dart';

class WHO5Survey implements RPSurvey {
  @override
  String get id => "who5";

  @override
  String get title => "WHO5 Well-Being";
  
  @override
  String get description => "A short 5-item survey on your well-being.";

  @override
  Duration get frequency => const Duration(minutes: 1);

  final RPChoiceAnswerFormat _choiceAnswerFormat = RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice,
    choices: [
      RPChoice(text: "All of the time", value: 5),
      RPChoice(text: "Most of the time", value: 4),
      RPChoice(text: "More than half of the time", value: 3),
      RPChoice(text: "Less than half of the time", value: 2),
      RPChoice(text: "Some of the time", value: 1),
      RPChoice(text: "At no time", value: 0),
    ],
  );

  @override
  RPOrderedTask get task => RPNavigableOrderedTask(
        identifier: "who5_survey",
        steps: [
          RPInstructionStep(
              identifier: 'who5',
              title: "WHO Well-Being Index",
              text:
                  "Please indicate for each of the following five statements which is closest to how you have been feeling over the last two weeks. "
                  "Notice that higher numbers mean better well-being.\n\n"
                  "Example: If you have felt cheerful and in good spirits more than half of the time during the last two weeks, "
                  "select the box with the label 'More than half of the time'."),
          RPQuestionStep(
            identifier: "who5_1",
            title: "I have felt cheerful and in good spirits",
            answerFormat: _choiceAnswerFormat,
          ),
          RPQuestionStep(
            identifier: "who5_2",
            title: "I have felt calm and relaxed",
            answerFormat: _choiceAnswerFormat,
          ),
          RPQuestionStep(
            identifier: "who5_3",
            title: "I have felt active and vigorous",
            answerFormat: _choiceAnswerFormat,
          ),
          RPQuestionStep(
            identifier: "who5_4",
            title: "I woke up feeling fresh and rested",
            answerFormat: _choiceAnswerFormat,
          ),
          RPQuestionStep(
            identifier: "who5_5",
            title: "My daily life has been filled with things that interest me",
            answerFormat: _choiceAnswerFormat,
          ),
          RPCompletionStep(
              identifier: "who5_ompletion",
              title: "Finished",
              text: "Thank you for filling out the survey!"),
        ],
      );
}