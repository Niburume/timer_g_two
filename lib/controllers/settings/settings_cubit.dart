import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../timer/timer_cubit.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  void setTabBarIndex(int index) {
    state.tabController.jumpToTab(index);
  }

  // void switchAutoMode() {
  //   emit(state.copyWith(autoMode: !state.autoMode));
  //
  // }
}
