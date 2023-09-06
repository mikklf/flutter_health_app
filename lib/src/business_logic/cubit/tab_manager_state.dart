part of 'tab_manager_cubit.dart';

sealed class TabManagerState extends Equatable {
  final int selectedTab;

  const TabManagerState(this.selectedTab);

  @override
  List<Object> get props => [selectedTab];
}

final class TabManagerInitial extends TabManagerState {
  const TabManagerInitial(int counter) : super(counter);
}
