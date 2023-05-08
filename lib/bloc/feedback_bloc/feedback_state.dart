// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class Initial extends FeedbackState {
  @override
  List<Object> get props => [];
}

class Loading extends FeedbackState {
  @override
  List<Object> get props => [];
}

class FeedbackSubmitted extends FeedbackState {
  @override
  List<Object> get props => [];
}

class FeedbackError extends FeedbackState {
  final String error;

  const FeedbackError(this.error);
  @override
  List<Object> get props => [error];
}
