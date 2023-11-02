import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/setup_cubit.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/location_permission_task_widget.dart';
import 'package:flutter_health_app/src/presentation/setup_screen/widgets/setup_task_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


class MockPermissionHandlerPlatform extends Mock
    with
        MockPlatformInterfaceMixin
    implements
        PermissionHandlerPlatform {
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) =>
      Future.value(PermissionStatus.granted);

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    var permissionsMap = <Permission, PermissionStatus>{};
    return Future.value(permissionsMap);
  }

}

void main() {
    late SetupCubit setupCubit;

  setUp(() {
    setupCubit = SetupCubit();
    PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
  });
  
  Widget createWidgetUnderTest() {
    return MaterialApp(
        home: BlocProvider<SetupCubit>(
      create: (context) => setupCubit,
      child: const LocationPermisionTaskWidget(),
    ));
  }

  group('LocationPermisionTaskWidget', () {
    testWidgets('Expect widget to contain a SetupTaskWidget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SetupTaskWidget), findsOneWidget);
    });

    testWidgets('Expect widget to show success when task is completed', (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

  });
}
