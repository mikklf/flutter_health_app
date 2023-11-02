import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_manager_state.dart';

class TabManagerCubit extends Cubit<TabManagerState> {
  TabManagerCubit() : super(const TabManagerState(0));

  /// Changes the selected tab.
  void changeTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }
}
