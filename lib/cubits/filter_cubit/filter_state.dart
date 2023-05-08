// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_cubit.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

// class DefaultFilter extends FilterState {
//   final Subject? subject;
//   final int? grade;
//   const DefaultFilter({
//     required this.grade,
//     required this.subject,
//   });
//   @override
//   List<Object> get props => [subject!];
// }

class GradeFilter extends FilterState {
  final int grade;
  const GradeFilter({required this.grade});
  @override
  List<Object> get props => [grade];
}

class SubjectFilter extends FilterState {
  final int grade;
  final Subject subject;
  const SubjectFilter({
    required this.grade,
    required this.subject,
  });
  @override
  List<Object> get props => [subject, grade];
}

class TopicFilter extends FilterState {
  final Subject subject;
  final Topic topic;
  final int grade;
  const TopicFilter(
      {required this.grade, required this.topic, required this.subject});
  @override
  List<Object> get props => [topic, subject, grade];
}

class ActivityFilter extends FilterState {
  final Subject subject;
  final Topic topic;
  final Activity activity;
  final int grade;
  const ActivityFilter({
    required this.grade,
    required this.subject,
    required this.topic,
    required this.activity,
  });
  @override
  List<Object> get props => [activity, topic, subject, grade];
}
