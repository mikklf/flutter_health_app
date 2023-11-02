import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/cubit/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/consent_task_widget.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/setup_task_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final consentTask = RPOrderedTask(
    identifier: "consent_task",
    steps: [
      RPCompletionStep(
          identifier: "completionID",
          title: "Thank You!",
          text: "We saved your consent document")
    ],
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => SetupCubit(),
        child: ConsentTaskWidget(consentTask: consentTask),
      ),
    );
  }

  group("ConsentTaskWidget", () {
    testWidgets('Expect ConsentTaskWidget to contain a SetupTaskWidget',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SetupTaskWidget), findsOneWidget);
    });

    testWidgets('Expect onPressed to navigate to consent screen',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(RPUITask), findsOneWidget);
    });

    testWidgets('Expect widget to show success when completing consent task',
        (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues(
          <String, Object>{'consent_given': false});
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text("DONE"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets(
        'Expect widget to show remain uncompleted canceling consent task',
        (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues(
          <String, Object>{'consent_given': false});
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Act
      // Press cross button
      await tester.tap(find.byIcon(Icons.highlight_off));
      await tester.pumpAndSettle();

      // Confirm cancel
      await tester.tap(find.text("YES"));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });
  });
}
