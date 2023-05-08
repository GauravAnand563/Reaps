part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();
}

class FetchQuestions extends QuizEvent {
  final String activityId;
  const FetchQuestions(this.activityId);

  @override
  List<String> get props => [activityId];
}

class MarkOption extends QuizEvent {
  final String questionId;
  final String optionKey;
  const MarkOption(this.questionId,this.optionKey);

  @override
  List<String> get props => [questionId,optionKey];
}
