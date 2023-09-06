part of '../survey_repository.dart';

List<RPChoice> _choices = [
    RPChoice(text: "All the time", value: 5),
    RPChoice(text: "Most of the time", value: 4),
    RPChoice(text: "More than half of the time", value: 3),
    RPChoice(text: "Less than half of the time", value: 2),
    RPChoice(text: "Some of the time", value: 1),
    RPChoice(text: "At no time", value: 0),
  ];

final _who5 = RPNavigableOrderedTask(
        identifier: "who5",
        steps: [
          RPQuestionStep(
            identifier: "who5Step1",
            title:
                "Over the last 2 weeks, i have felt cheerful and in good spirits?",
            answerFormat: RPChoiceAnswerFormat(
              answerStyle: RPChoiceAnswerStyle.SingleChoice,
              choices: _choices,
            ),
          ),
          RPQuestionStep(
            identifier: "who5Step2",
            title: "Over the last 2 weeks, i have felt calm and relaxed?",
            answerFormat: RPChoiceAnswerFormat(
              answerStyle: RPChoiceAnswerStyle.SingleChoice,
              choices: _choices,
            ),
          ),
          RPFormStep(
              identifier: "who5_Step_345",
              title: "who5 Questions 3,4 and 5",
              questions: [
                RPQuestionStep(
                  identifier: "who5Step3",
                  title:
                      "Over the last 2 weeks, i have felt active and vigorous?",
                  answerFormat: RPChoiceAnswerFormat(
                    answerStyle: RPChoiceAnswerStyle.SingleChoice,
                    choices: _choices,
                  ),
                ),
                RPQuestionStep(
                  identifier: "who5Step4",
                  title:
                      "Over the last 2 weeks, i woke up feeling fresh and rested?",
                  answerFormat: RPChoiceAnswerFormat(
                    answerStyle: RPChoiceAnswerStyle.SingleChoice,
                    choices: _choices,
                  ),
                ),
                RPQuestionStep(
                  identifier: "who5Step5",
                  title:
                      "Over the last 2 weeks, my daily life has been filled with things that interest me?",
                  answerFormat: RPChoiceAnswerFormat(
                    answerStyle: RPChoiceAnswerStyle.SingleChoice,
                    choices: _choices,
                  ),
                )
              ]),
          RPCompletionStep(
            identifier: "who5CompletionStep",
            title: "Finished",
            text: "Thank you for filling out the survey!",
          )
        ],
        
      );