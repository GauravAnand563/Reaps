// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class Initial extends RegistrationState {
  @override
  List<Object> get props => [];
}

class Loading extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RegistrationCompleted extends RegistrationState {
  @override
  List<Object> get props => [];
}

class GradesLoaded extends RegistrationState {
  final List<int> grades;

  const GradesLoaded({required this.grades});
  @override
  List<Object> get props => [];
}

class SubjectsLoaded extends RegistrationState {
  final List<String> subjects;

  const SubjectsLoaded({required this.subjects});
  @override
  List<List<String>> get props => [subjects];
}

class RegistrationError extends RegistrationState {
  final String error;

  const RegistrationError(this.error);
  @override
  List<Object> get props => [error];
}
