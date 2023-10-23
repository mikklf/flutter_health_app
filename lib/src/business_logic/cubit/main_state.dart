part of 'main_cubit.dart';

@immutable
abstract class MainState {}

class InitialMainState extends MainState {}

class SetupRequiredState extends MainState {}

class SetupCompletedState extends MainState {}
