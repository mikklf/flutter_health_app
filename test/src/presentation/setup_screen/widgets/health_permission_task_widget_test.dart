import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/di.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/health_permission_task_widget.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/setup_task_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHealthProvider extends Mock implements IHealthProvider {}

void main() {
  late SetupCubit setupCubit;

  setUp(() {
    // Register services
    ServiceLocator.setupDependencyInjection();

    // Replace services with mocks
    services.unregister<IHealthProvider>();
    services.registerSingleton<IHealthProvider>(MockHealthProvider());

    setupCubit = SetupCubit();
  });

  tearDown(() {
    setupCubit.close();
    services.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
        home: BlocProvider<SetupCubit>(
      create: (context) => setupCubit,
      child: const HealthPermisionTaskWidget(),
    ));
  }

  group('HealthPermisionTaskWidget', () {
    testWidgets('Expect widget to contain a SetupTaskWidget',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SetupTaskWidget), findsOneWidget);
    });

    testWidgets('Expect widget to show success when permission was granted',
        (tester) async {
      // arrange
      when(() => services.get<IHealthProvider>().requestAuthorization())
          .thenAnswer((_) async => true);

      SharedPreferences.setMockInitialValues(<String, Object>{});

      await tester.pumpWidget(createWidgetUnderTest());

      // act
      await tester.tap(find.text('Reauthorize'));
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Expect widget to show remain uncompleted when permission was denied',
        (tester) async {
      // arrange
      when(() => services.get<IHealthProvider>().requestAuthorization())
          .thenAnswer((_) async => false);

      SharedPreferences.setMockInitialValues(<String, Object>{});

      await tester.pumpWidget(createWidgetUnderTest());

      // act
      await tester.tap(find.text('Reauthorize'));
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });
  });
}
