// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'activity_cubit.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class GradesFetchSuccess extends ActivityState {
  final List<int>? grades;
  const GradesFetchSuccess({
    required this.grades,
  });

  @override
  String toString() => 'GradesFetchSuccess(grades: $grades)';

  @override
  List<Object> get props => [grades!];
}

class GradesFetchInProgress extends ActivityState {}

class GradesFetchError extends ActivityState {
  final String error;
  const GradesFetchError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class SubjectsFetchSuccess extends ActivityState {
  final List<int>? grades;
  final List<Subject>? subjects;
  const SubjectsFetchSuccess({
    required this.grades,
    required this.subjects,
  });

  @override
  String toString() =>
      'SubjectsFetchSuccess(grades: $grades, subjects: $subjects)';

  @override
  List<Object> get props => [subjects!, grades!];
}

class SubjectsFetchInProgress extends ActivityState {
  final List<int>? grades;
  const SubjectsFetchInProgress({required this.grades});

  @override
  List<Object> get props => [grades!];
}

class SubjectsFetchError extends ActivityState {
  final String error;
  const SubjectsFetchError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class TopicsFetchSuccess extends ActivityState {
  final List<int>? grades;
  final List<Subject>? subjects;
  final List<Topic>? topics;
  const TopicsFetchSuccess({
    required this.grades,
    required this.subjects,
    required this.topics,
  });

  @override
  List<Object> get props => [topics!, subjects!, grades!];

  @override
  String toString() =>
      'TopicsFetchSuccess(grades: $grades, subjects: $subjects, topics: $topics)';
}

class TopicsFetchInProgress extends ActivityState {
  final List<Subject>? subjects;
  final List<int>? grades;

  const TopicsFetchInProgress({required this.subjects, required this.grades});

  @override
  String toString() =>
      'TopicsFetchInProgress(subjects: $subjects, grades: $grades)';

  @override
  List<Object> get props => [subjects!, grades!];
}

class TopicsFetchError extends ActivityState {
  final String error;
  const TopicsFetchError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}

class ActivitiesFetchSuccess extends ActivityState {
  final List<int>? grades;
  final List<Subject>? subjects;
  final List<Topic>? topics;
  final List<Activity>? activities;
  const ActivitiesFetchSuccess(
      {required this.activities,
      required this.grades,
      required this.subjects,
      required this.topics});

  @override
  String toString() {
    return 'ActivitiesFetchSuccess(grades: $grades, subjects: $subjects, topics: $topics, activities: $activities)';
  }

  @override
  List<Object> get props => [activities!, topics!, subjects!, grades!];
}

class ActivitiesFetchInProgress extends ActivityState {
  final List<int>? grades;
  final List<Subject>? subjects;
  final List<Topic>? topics;

  const ActivitiesFetchInProgress(
      {required this.subjects, required this.grades, required this.topics});

  @override
  String toString() =>
      'ActivitiesFetchInProgress(subjects: $subjects, topics: $topics)';

  @override
  List<Object> get props => [subjects!, topics!, grades!];
}

class ActivitiesFetchError extends ActivityState {
  final String error;
  const ActivitiesFetchError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
