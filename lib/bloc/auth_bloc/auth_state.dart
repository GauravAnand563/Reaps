// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Loading extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final User firebaseUser;

  const Authenticated({required this.firebaseUser});

  @override
  List<Object> get props => [firebaseUser];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);
  @override
  List<Object> get props => [error];
}
