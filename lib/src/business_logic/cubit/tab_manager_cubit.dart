import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_manager_state.dart';

class TabManagerCubit extends Cubit<TabManagerState> {
  TabManagerCubit() : super(const TabManagerInitial(0));

  void changeTab(int index) {
    emit(TabManagerInitial(index));
  }
}
