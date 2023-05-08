part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
}

class FetchGrades extends FeedbackEvent {
  const FetchGrades();

  @override
  List<Object> get props => [];
}

class FetchSubjectByGrade extends FeedbackEvent {
  final int grade;

  const FetchSubjectByGrade(this.grade);

  @override
  List<int> get props => [grade];
}

class SubmitFeedback extends FeedbackEvent {
  final String id;
  final String rating;
  final String feedback;

  const SubmitFeedback(this.id, this.rating, this.feedback);

  @override
  List<Object> get props => [id, rating, feedback];
}

class UpdateDetails extends FeedbackEvent {
  @override
  List<Object> get props => [];
}
