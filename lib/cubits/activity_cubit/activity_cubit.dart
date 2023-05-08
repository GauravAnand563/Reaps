import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/db_repo.dart';
import '../../models/activity_data.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final DatabaseRepository _repo;

  ActivityCubit(this._repo) : super(GradesFetchInProgress());

  Future<void> fetchGrades() async {
    emit(GradesFetchInProgress());
    try {
      final List<int>? grades = await _repo.getGrades();
      emit(GradesFetchSuccess(grades: grades));
    } catch (e) {
      emit(GradesFetchError(error: e.toString()));
    }
  }

  Future<void> fetchSubjects(int grade, List<int>? grades) async {
    emit(SubjectsFetchInProgress(grades: grades));
    try {
      final List<Subject>? subjects = await _repo.getSubjects(grade);
      emit(SubjectsFetchSuccess(subjects: subjects, grades: grades));
    } catch (e) {
      emit(SubjectsFetchError(error: e.toString()));
    }
  }

  void fetchTopics(
      String subjectId, List<Subject>? subjects, List<int>? grades) async {
    emit(TopicsFetchInProgress(subjects: subjects, grades: grades));
    try {
      final List<Topic>? topics = await _repo.getTopic(subjectId);
      emit(TopicsFetchSuccess(
          topics: topics, subjects: subjects, grades: grades));
    } catch (e) {
      emit(TopicsFetchError(error: e.toString()));
    }
  }

  void fetchActivities(String topicId, List<Subject>? subjects,
      List<Topic>? topics, List<int>? grades) async {
    emit(ActivitiesFetchInProgress(
        subjects: subjects, topics: topics, grades: grades));
    try {
      final List<Activity>? activities = await _repo.getActivity(topicId);
      emit(ActivitiesFetchSuccess(
          activities: activities,
          subjects: subjects,
          topics: topics,
          grades: grades));
    } catch (e) {
      emit(ActivitiesFetchError(error: e.toString()));
    }
  }
}
