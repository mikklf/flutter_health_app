part of '../survey_repository.dart';

List<RPChoice> _yesNo = [
  RPChoice(text: "Yes", value: 1),
  RPChoice(text: "No", value: 0),
];

List<RPChoice> _trueFalse = [
  RPChoice(text: "True", value: 1),
  RPChoice(text: "False", value: 0),
];

RPOrderedTask _kellner = RPNavigableOrderedTask(identifier: "kellner", steps: [
  RPInstructionStep(
    identifier: "kellnerInstruction",
    title: "Instructions",
    detailText:
        """For each statement, please press the button corresponding to your answer\n 
For example, when prompted with the word 'Nervous', press the 'Yes' button if you have felt nervous, or the 'No' button if you have not felt nervous.\n 
Similarly, for statements like 'Feeling of not enough air', press the 'TRUE' button if you genuinely experienced that feeling, or the 'FALSE' button if you did not.\n
Don't think much before answering. Thank you.""",
    text:
        "For the upcoming questions choose the answer closest to how you felt during the past week.",
  ),
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
]);
