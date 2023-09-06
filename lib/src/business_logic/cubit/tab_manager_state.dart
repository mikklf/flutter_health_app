part of 'tab_manager_cubit.dart';

@immutable
sealed class TabManagerState {
  final int selectedTab;
  const TabManagerState(this.selectedTab);
}

final class TabManagerInitial extends TabManagerState {
  const TabManagerInitial(int counter) : super(counter);
}
