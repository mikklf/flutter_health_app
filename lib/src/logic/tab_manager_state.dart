part of 'tab_manager_cubit.dart';

final class TabManagerState extends Equatable {
  /// The index of the currently selected tab.
  final int selectedTab;

  const TabManagerState(this.selectedTab);

  @override
  List<Object> get props => [selectedTab];

  /// Returns a copy of [TabManagerState] with the given fields replaced with the new values.
  TabManagerState copyWith({
    int? selectedTab,
  }) {
    return TabManagerState(
      selectedTab ?? this.selectedTab,
    );
  }
}