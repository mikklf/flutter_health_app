import 'package:flutter/material.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/domain/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/widgets/weight_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:research_package/ui.dart';

class MockWeightRepository extends Mock implements IWeightRepository {}

void main() {
  group('WeightWidget', () {
    setUp(() {
      // Register services
      ServiceLocator.setupDependencyInjection();

      // Replace services with mocks
      services.unregister<IWeightRepository>();
      services.registerSingleton<IWeightRepository>(MockWeightRepository());

      // Register mock behaviour
      when(() => services<IWeightRepository>().getLatestWeights(any()))
          .thenAnswer((_) async {
        return [];
      });
    });

    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: WeightWidget(),
      );
    }

    tearDown(() {
      services.reset(dispose: true);
    });

    testWidgets('Expect weight widget to have a weight update button',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Expect weight widget to have a weight chart', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(charts.TimeSeriesChart), findsOneWidget);
    });

    testWidgets("Expect new screen when clicking button", (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(RPUITask), findsOneWidget);
      
    });
  });
}
