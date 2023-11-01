import 'package:research_package/model.dart';

import 'surveys.dart';

/// A dummy survey used for testing
class DummySurvey implements RPSurvey {
      @override
      String get id => "dummy";

      @override
      String get title => "Dummy Survey";

      @override
      String get description => "A zero question survey used for testing";

      @override
      Duration get frequency => const Duration(minutes: 1);

      @override
      RPOrderedTask get task => RPNavigableOrderedTask(
        identifier: "dummy_survey",
        steps: [
          RPCompletionStep(
          identifier: "dummy_completion_step",
          title: "Finished",
          text: "Thank you for completing the survey!",
        ),
        ],
      );

    }