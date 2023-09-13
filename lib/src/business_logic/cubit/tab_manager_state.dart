part of 'tab_manager_cubit.dart';

final class TabManagerState extends Equatable {
  final int selectedTab;

  const TabManagerState(this.selectedTab);

  @override
  List<Object> get props => [selectedTab];

  TabManagerState copyWith({
    int? selectedTab,
  }) {
    return TabManagerState(
      selectedTab ?? this.selectedTab,
    );
  }
}