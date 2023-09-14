import 'package:flutter/material.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      title: 'Overview Screen Test',
      home: OverviewScreen(),
    );
  }

  testWidgets('Overview Screen has a text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Overview Screen'), findsOneWidget);
  });
}
