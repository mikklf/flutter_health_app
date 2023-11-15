import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/helpers/preprocessor_helper.dart';
import 'package:flutter_health_app/src/data/data_preprocessing/interfaces/data_preprocessor.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/heart_rate_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/home_stay_widget.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/weather_widget.dart';
import 'package:flutter_health_app/survey_objects/result_parsers/kellner_result_parser.dart';
import 'package:health/health.dart';

import 'widgets/steps_widget.dart';
import 'widgets/weight_widget.dart';

// TESTING SHOULD BE REMOVED!
import 'package:flutter_health_app/src/data/dataproviders/helpers/health_helper.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // TESTING SHOULD BE REMOVED!
        Column(
          children: [
            ElevatedButton(
                onPressed: _healthHeartRateButtonPressed,
                child: const Text("Test Heart rate")),
            ElevatedButton(
                onPressed: _healthStepsButtonPressed,
                child: const Text("Test Steps")),
            ElevatedButton(
                onPressed: _testDbButtonPressed, child: const Text("Test db")),
            ElevatedButton(
                onPressed: _testResultParsePressed,
                child: const Text("Test result parse")),
            ElevatedButton(
                onPressed: () async {
                  context.read<SetupCubit>().resetSetup();
                },
                child: const Text("Reset setup"))
          ],
        ),

        // Register widgets here
        const StepsWidget(),
        const WeightWidget(),
        const HomeStayWidget(),
        const HeartRateWidget(),
        const WeatherWidget(),
      ],
    );
  }

  /// TESTING SHOULD BE REMOVED!
  void _healthStepsButtonPressed() async {
    var stepRepository = services.get<IStepRepository>();

    HealthFactory healthFactory = await HealthHelper.getHealthFactory();

    var now = DateTime.now();
    var earlier = now.subtract(const Duration(minutes: 5));

    healthFactory.writeHealthData(500, HealthDataType.STEPS, earlier, now);

    var startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var databaseSteps =
        await stepRepository.getStepsInRange(startOfDay, endOfDay);

    var stepsInDb = databaseSteps.isNotEmpty ? databaseSteps.first.steps : 0;

    var healthProvider = services.get<IHealthProvider>();
    var healthSteps = await healthProvider.getSteps(startOfDay, endOfDay);

    debugPrint("Steps in DB for day: $stepsInDb");
    debugPrint("Steps in Health for day: $healthSteps");
  }

  /// TESTING SHOULD BE REMOVED!
  void _healthHeartRateButtonPressed() async {
    var heartRateRepository = services.get<IHeartRateRepository>();

    HealthFactory healthFactory = await HealthHelper.getHealthFactory();

    var now = DateTime.now();

    healthFactory.writeHealthData(
        80, HealthDataType.HEART_RATE, DateTime.now(), DateTime.now());

    var startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var databaseHeartRate =
        await heartRateRepository.getHeartRatesInRange(startOfDay, endOfDay);

    var healthProvider = services.get<IHealthProvider>();
    var healthHeartRate =
        await healthProvider.getHeartbeats(startOfDay, endOfDay);

    var countDb = databaseHeartRate.length;
    var countHealth = healthHeartRate.length;

    debugPrint("Heart rate count in DB for day: $countDb");
    debugPrint("Heart rate count in Health for day: $countHealth");
  }

  /// TESTING SHOULD BE REMOVED!
  void _testDbButtonPressed() async {
    var processor = services.get<IDataPreprocessor>();

    var startTime = DateTime(1994, 1, 1);
    var endTime = DateTime(2023, 11, 15);

    debugPrint(PreprocessorHelper.toCsv(
        await processor.getPreprocessedData(startTime, endTime)));
  }

  /// TESTING SHOULD BE REMOVED!
  void _testResultParsePressed() async {
    var score = KellnerResultParser.parse(kellnerJsonText);

    debugPrint("Kellner score: $score");
  }
}

const String kellnerJsonText =
    '{"identifier":"kellner","start_date":"2023-11-15T08:45:45.634270","end_date":"2023-11-15T08:46:12.100660","results":{"kellnerQuestions":{"identifier":"kellnerQuestions","start_date":"2023-11-15T08:45:46.596203","end_date":"2023-11-15T08:45:46.596493","question_title":"Form Step - See titles for every question included","results":{"kellnerItem2":{"identifier":"kellnerItem2","start_date":"2023-11-15T08:45:46.596213","end_date":"2023-11-15T08:45:48.190404","question_title":"Weary","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem4":{"identifier":"kellnerItem4","start_date":"2023-11-15T08:45:46.596229","end_date":"2023-11-15T08:45:49.429291","question_title":"Cheerful","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false},{"__type":"RPChoice","text":"No","value":1,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem6":{"identifier":"kellnerItem6","start_date":"2023-11-15T08:45:46.596241","end_date":"2023-11-15T08:45:50.044544","question_title":"Sad, blue","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem7":{"identifier":"kellnerItem7","start_date":"2023-11-15T08:45:46.596253","end_date":"2023-11-15T08:45:51.070231","question_title":"Happy","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false},{"__type":"RPChoice","text":"No","value":1,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem24":{"identifier":"kellnerItem24","start_date":"2023-11-15T08:45:46.596265","end_date":"2023-11-15T08:45:51.931533","question_title":"Feeling unworthy","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem27":{"identifier":"kellnerItem27","start_date":"2023-11-15T08:45:46.596278","end_date":"2023-11-15T08:45:52.742327","question_title":"Cannot enjoy yourself","results":{"answer":[{"__type":"RPChoice","text":"True","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"True","value":1,"is_free_text":false},{"__type":"RPChoice","text":"False","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem39":{"identifier":"kellnerItem39","start_date":"2023-11-15T08:45:46.596290","end_date":"2023-11-15T08:45:53.554689","question_title":"Feeling guilty","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem40":{"identifier":"kellnerItem40","start_date":"2023-11-15T08:45:46.596302","end_date":"2023-11-15T08:45:54.344533","question_title":"Feeling well","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false},{"__type":"RPChoice","text":"No","value":1,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem43":{"identifier":"kellnerItem43","start_date":"2023-11-15T08:45:46.596314","end_date":"2023-11-15T08:45:55.154714","question_title":"Contented","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false},{"__type":"RPChoice","text":"No","value":1,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem45":{"identifier":"kellnerItem45","start_date":"2023-11-15T08:45:46.596329","end_date":"2023-11-15T08:45:56.003536","question_title":"Feeling desperate, terrible","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"KellnerItem47":{"identifier":"Thinking of death or dying","start_date":"2023-11-15T08:45:46.596341","end_date":"2023-11-15T08:45:56.738630","question_title":"Nervous","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem51":{"identifier":"kellnerItem51","start_date":"2023-11-15T08:45:46.596353","end_date":"2023-11-15T08:45:57.566574","question_title":"Enjoying yourself","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false},{"__type":"RPChoice","text":"No","value":1,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem58":{"identifier":"kellnerItem58","start_date":"2023-11-15T08:45:46.596365","end_date":"2023-11-15T08:45:58.409460","question_title":"Depressed","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem60":{"identifier":"kellnerItem60","start_date":"2023-11-15T08:45:46.596377","end_date":"2023-11-15T08:45:59.147718","question_title":"Feeling a failure","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem61":{"identifier":"kellnerItem61","start_date":"2023-11-15T08:45:46.596389","end_date":"2023-11-15T08:46:00.141976","question_title":"Not interested in things","results":{"answer":[{"__type":"RPChoice","text":"True","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"True","value":1,"is_free_text":false},{"__type":"RPChoice","text":"False","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem66":{"identifier":"kellnerItem66","start_date":"2023-11-15T08:45:46.596401","end_date":"2023-11-15T08:46:01.559791","question_title":"Blaming yourself","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem67":{"identifier":"kellnerItem67","start_date":"2023-11-15T08:45:46.596413","end_date":"2023-11-15T08:46:02.390545","question_title":"Thoughts of ending your life","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem71":{"identifier":"kellnerItem71","start_date":"2023-11-15T08:45:46.596426","end_date":"2023-11-15T08:46:03.238853","question_title":"Looking forward toward the future","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":0,"is_free_text":false},{"__type":"RPChoice","text":"No","value":1,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem73":{"identifier":"kellnerItem73","start_date":"2023-11-15T08:45:46.596439","end_date":"2023-11-15T08:46:04.272787","question_title":"Feeling that life is bad","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem75":{"identifier":"kellnerItem75","start_date":"2023-11-15T08:45:46.596451","end_date":"2023-11-15T08:46:05.438731","question_title":"Feeling inferior to others","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem76":{"identifier":"kellnerItem76","start_date":"2023-11-15T08:45:46.596463","end_date":"2023-11-15T08:46:06.560870","question_title":"Feeling useless","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem84":{"identifier":"kellnerItem84","start_date":"2023-11-15T08:45:46.596475","end_date":"2023-11-15T08:46:07.576857","question_title":"Feel like crying","results":{"answer":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}},"kellnerItem91":{"identifier":"kellnerItem91","start_date":"2023-11-15T08:45:46.596487","end_date":"2023-11-15T08:46:09.232873","question_title":"Feeling of hopelesness","results":{"answer":[{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}]},"answer_format":{"__type":"RPChoiceAnswerFormat","question_type":"SingleChoice","choices":[{"__type":"RPChoice","text":"Yes","value":1,"is_free_text":false},{"__type":"RPChoice","text":"No","value":0,"is_free_text":false}],"answer_style":"SingleChoice"}}},"answer_format":{"__type":"RPFormAnswerFormat","question_type":"Form"}}}}';
