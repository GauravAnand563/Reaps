// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
  const AuthEvent();
}

class GoogleSignInRequested extends AuthEvent {}

class Authenticate extends AuthEvent {
  final User firebaseUser;

  const Authenticate({required this.firebaseUser});

  @override
  List<Object?> get props => [firebaseUser];
}

class SignOutRequested extends AuthEvent {}
