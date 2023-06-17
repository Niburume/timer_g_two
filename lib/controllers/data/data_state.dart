part of 'data_cubit.dart';

class DataState extends Equatable {
  String currentUserId;
  List<Project> projects;
  Project? currentProject;
  TimeEntry? currentTimeEntry;

  DataState(
      {required this.currentUserId,
      required this.projects,
      required this.currentProject,
      required this.currentTimeEntry});

  // default values
  factory DataState.initial() => DataState(
      currentUserId: '',
      projects: [],
      currentProject: null,
      currentTimeEntry: null);

  @override
  List<Object?> get props =>
      [currentUserId, projects, currentProject, currentTimeEntry];

  DataState copyWith({
    String? currentUserId,
    List<Project>? projects,
    Project? currentProject,
    TimeEntry? currentTimeEntry,
  }) {
    return DataState(
        currentTimeEntry: currentTimeEntry ?? this.currentTimeEntry,
        currentUserId: currentUserId ?? this.currentUserId,
        currentProject: currentProject ?? this.currentProject,
        projects: projects ?? this.projects);
  }
}
