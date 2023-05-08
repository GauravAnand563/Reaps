// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class Loading extends UserState {
  @override
  List<Object> get props => [];
}

class Initial extends UserState {
  @override
  List<Object> get props => [];
}

class Pending extends UserState {
  final UserData userData;

  const Pending({required this.userData});
  @override
  List<Object> get props => [];
}

class Completed extends UserState {
  final UserData userData;

  const Completed({required this.userData});
  @override
  List<Object> get props => [];
}

class UserError extends UserState {
  final String error;

  const UserError(this.error);
  @override
  List<Object> get props => [error];
}
