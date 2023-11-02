import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/logic/cubit/weather_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/weather_provider.dart';
import 'package:flutter_health_app/src/data/models/weather.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/weather_repository.dart';
import 'package:flutter_health_app/src/presentation/overview_screen/widgets/weather_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements IWeatherRepository {}

void main() {
  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace services with mocks
    services.unregister<IWeatherRepository>();
    services.registerSingleton<IWeatherRepository>(MockWeatherRepository());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider(
        lazy: false,
        create: (context) => WeatherCubit(services.get<IWeatherRepository>(),
            services.get<IWeatherProvider>()),
        child: const WeatherWidget(),
      ),
    );
  }

  tearDown(() {
    services.reset(dispose: true);
  });

  group('WeightWidget', () {
    testWidgets('Expect WeatherWidget to not display when no data is available',
        (tester) async {
      when(() => services<IWeatherRepository>().getLastest())
          .thenAnswer((_) async => null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets(
        'Expect WeatherWidget to display when only temperature is available',
        (tester) async {
      when(() => services<IWeatherRepository>().getLastest()).thenAnswer(
          (_) async =>
              Weather(temperature: 18, timestamp: DateTime(2023, 11, 1)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Expect WeatherWidget to display weather data', (tester) async {
      when(() => services<IWeatherRepository>().getLastest())
          .thenAnswer((_) async => Weather(
                temperature: 20.0,
                temperatureFeelsLike: 19.0,
                humidity: 50,
                cloudinessPercent: 20,
                timestamp: DateTime(2023, 11, 1),
                sunset: DateTime(2023, 11, 1, 18, 44),
                weatherdescription: "Sunny",
                weatherCondition: "Clear",
              ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text("Weather"), findsOneWidget);
      expect(find.text("20 °C"), findsOneWidget);
      expect(find.text("19 °C"), findsOneWidget);
      expect(find.text("50 %"), findsOneWidget);
      expect(find.text("20 %"), findsOneWidget);
      expect(find.text("Sunny"), findsOneWidget);
      expect(find.text("N/A"), findsOneWidget);
      expect(find.text("18:44"), findsOneWidget);
    });
  });
}
