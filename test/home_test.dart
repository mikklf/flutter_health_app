import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/presentation/home_screen.dart';
import 'package:flutter_health_app/src/logic/tab_manager_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    const pages = [
      Text("OverviewScreen"),
      Text("SurveyDashboard"),
    ];

    return MaterialApp(
        title: 'home Test',
        home: BlocProvider(
          create: (context) => TabManagerCubit(),
          child: const HomeScreen(pages: pages),
        ));
  }

  group("Home", () {
    testWidgets('Expect App bar', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Expect Bottom navigation bar with two items', (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      var navbar = find.byType(BottomNavigationBar);
      final BottomNavigationBar bottomNavBar =
          tester.widget(find.byType(BottomNavigationBar));

      // Assert
      expect(navbar, findsOneWidget);
      expect(bottomNavBar.items.length, 2);
    });

    testWidgets('Initial selected tab is 0 and home page is OverviewScreen',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final BottomNavigationBar bottomNavBar =
          tester.widget(find.byType(BottomNavigationBar));

      // Assert
      expect(bottomNavBar.currentIndex, 0);
      expect(find.text("OverviewScreen"), findsOneWidget);
      expect(find.text("SurveyDashboard"), findsNothing);
    });

    testWidgets('Expect IndexedStack with two childrens', (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      expect(find.byType(IndexedStack), findsOneWidget);
      final IndexedStack indexedStack =
          tester.widget(find.byType(IndexedStack));
      expect(indexedStack.index, 0);
      expect(indexedStack.children.length, 2);
    });

    testWidgets("Tapping survey page should change page", (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.byIcon(Icons.book));
      await tester.pump();

      // Assert
      expect(find.text("OverviewScreen"), findsNothing);
      expect(find.text("SurveyDashboard"), findsOneWidget);

      final BottomNavigationBar bottomNavBar =
          tester.widget(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, 1);
    });
  });
}
