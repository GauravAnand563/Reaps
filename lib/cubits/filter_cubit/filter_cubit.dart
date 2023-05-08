import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/activity_data.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final Subject? subjectPreferred;
  final int? grade;
  FilterCubit({this.subjectPreferred, this.grade})
      : super(SubjectFilter(subject: subjectPreferred!, grade: grade!));

  void filterByGrade(int _grade) {
    emit(GradeFilter(grade: _grade));
  }

  void filterBySubject(int _grade, Subject _subject) {
    emit(SubjectFilter(subject: _subject, grade: _grade));
  }

  void filterByTopic(Topic _topic, Subject _subject, int _grade) {
    emit(TopicFilter(topic: _topic, subject: _subject, grade: _grade));
  }

  void filterByActivity(
      Activity _activity, Topic _topic, Subject _subject, int _grade) {
    emit(ActivityFilter(
        activity: _activity, topic: _topic, subject: _subject, grade: _grade));
  }
}
