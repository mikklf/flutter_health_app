import 'package:research_package/research_package.dart';

import 'surveys.dart';

class WeeklySleepQualitySurvey implements RPSurvey {
  @override
  String get id => "weekly_sleep_quality";

  @override
  String get title => "Weekly Sleep Quality";

  @override
  String get description => "Rate your sleep quality for the past 7 days.";

  @override
  Duration get frequency => const Duration(days: 7);

  final _timeOfDayAnswerFormat = RPDateTimeAnswerFormat(
      dateTimeAnswerStyle: RPDateTimeAnswerStyle.TimeOfDay);

  final _minutesIntegerAnswerFormat =
      RPIntegerAnswerFormat(minValue: 0, maxValue: 10000, suffix: "minutes");

  final _hoursIntegerAnswerFormat =
      RPIntegerAnswerFormat(minValue: 0, maxValue: 10000, suffix: "hours");

  final RPChoiceAnswerFormat _frequencyChoiceAnswerFormat =
      RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice,
    choices: [
      RPChoice(text: "Everyday", value: 3),
      RPChoice(text: "Five or six times", value: 3),
      RPChoice(text: "Two to five times", value: 2),
      RPChoice(text: "Once", value: 1),
      RPChoice(text: "None", value: 0),
    ],
  );

  final RPChoiceAnswerFormat _sleepQualityOverallChoiceAnswerFormat =
      RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice,
    choices: [
      RPChoice(text: "Very good", value: 3),
      RPChoice(text: "Fairly good", value: 2),
      RPChoice(text: "Farily bad", value: 1),
      RPChoice(
        text: "Very bad",
        value: 0,
      ),
    ],
  );

  @override
  RPOrderedTask get task => RPNavigableOrderedTask(identifier: "PSQI", steps: [
        RPInstructionStep(
          identifier: "weekly_sleep_quality_Instructions",
          title: "Instructions",
          text:
              "The following questions relate to your usual sleep habits during the past week only. Your answers should indicate the most accurate reply for the majority of days and nights in the past week.",
        ),
        RPFormStep(
            identifier: "weekly_sleep_quality_Questions1",
            title: "During the past week...",
            questions: [
              RPQuestionStep(
                identifier: "weekly_sleep_quality_Questions1_step1",
                title: "What time have you usaually gone to bed at night?",
                answerFormat: _timeOfDayAnswerFormat,
              ),
              RPQuestionStep(
                identifier: "weekly_sleep_quality_Questions1_step2",
                title:
                    "How long (in minutes) has it usaually taken you to fall asleep each night?",
                answerFormat: _minutesIntegerAnswerFormat,
              ),
              RPQuestionStep(
                identifier: "weekly_sleep_quality_Questions1_step3",
                title: "What time have you usually gotten up in the morning?",
                answerFormat: _timeOfDayAnswerFormat,
              ),
              RPQuestionStep(
                identifier: "weekly_sleep_quality_Questions1_step4",
                title:
                    "How many hours of actual sleep did you get at night? (This may be different than the number of hours you spent in bed.)",
                answerFormat: _hoursIntegerAnswerFormat,
              ),
            ]),
        RPFormStep(
            identifier: "weekly_sleep_quality_Questions2",
            title:
                "During the past week, how often have you had trouble sleeping becuase you...",
            questions: [
              RPQuestionStep(
                  identifier: "weekly_sleep_quality_Questions2_step1",
                  title: "Cannot get to sleep within 30 minutes",
                  answerFormat: _frequencyChoiceAnswerFormat),
              RPQuestionStep(
                  identifier: "weekly_sleep_quality_Questions2_step2",
                  title: "Wake up in the middle of the night or early morning?",
                  answerFormat: _frequencyChoiceAnswerFormat),
              RPQuestionStep(
                  identifier: "weekly_sleep_quality_Questions2_step3",
                  title: "Have pain",
                  answerFormat: _frequencyChoiceAnswerFormat),
              RPQuestionStep(
                  identifier: "weekly_sleep_quality_Questions2_step4",
                  title: "Have excessive thoughts",
                  answerFormat: _frequencyChoiceAnswerFormat),
            ]),
        RPFormStep(
            identifier: "weekly_sleep_quality_Questions3",
            title:
                "During the past week, how would you rate your...",
            questions: [
              RPQuestionStep(
                  identifier: "weekly_sleep_quality_Questions3_step1",
                  title: "Overall sleep quality",
                  answerFormat: _sleepQualityOverallChoiceAnswerFormat),
            ]),
        RPCompletionStep(
          identifier: "weekly_sleep_quality_Completion",
          title: "Finished",
          text: "Thank you for completing the survey!",
        ),
      ]);
}
