// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_bloc.dart';

@immutable
abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

class Loading extends QuizState {
  @override
  List<Object> get props => [];
}

class Loaded extends QuizState {
  final ActivityQuestions activityQuestions;
  final QuestionResponses questionResponses;
  const Loaded({required this.activityQuestions,required this.questionResponses});
  @override
  List<Object> get props => [activityQuestions,questionResponses];
}

class QuizError extends QuizState {
  final String error;

  const QuizError(this.error);
  @override
  List<Object> get props => [error];
}
