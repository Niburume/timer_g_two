import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Models/project_model.dart';
import '../../Models/time_entry_model.dart';
import '../../helpers/db_helper.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataState.initial());

  // region USERS
  void setUserId(String userId) {
    emit(state.copyWith(currentUserId: userId));
  }

  // endregion
  // region PROJECTS
  Future<void> queryAllProjects() async {
    var projects = await DBHelper.instance.queryAllProjects();
    emit(state.copyWith(projects: projects));
  }

  void setCurrentProject(Project project) {
    emit(state.copyWith(currentProject: project));
  }

  // endregion
  // region TIME ENTRIES
  void setCurrentTimeEntry(TimeEntry timeEntry) {
    emit(state.copyWith(currentTimeEntry: timeEntry));
  }

// endregion
}
