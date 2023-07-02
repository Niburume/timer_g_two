part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  PersistentTabController tabController;
  bool autoMode;

  SettingsState({required this.tabController, required this.autoMode});

  factory SettingsState.initial() => SettingsState(
      tabController: PersistentTabController(initialIndex: 0), autoMode: false);

  @override
  List<Object> get props => [tabController, autoMode];

  SettingsState copyWith(
      {PersistentTabController? tabController, bool? autoMode}) {
    return SettingsState(
        tabController: tabController ?? this.tabController,
        autoMode: autoMode ?? this.autoMode);
  }
}
