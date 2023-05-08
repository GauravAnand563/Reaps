part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class RegisterUser extends UserEvent {
  final UserData userData;

  const RegisterUser(this.userData);

  @override
  List<UserData> get props => [userData];
}

class FetchUser extends UserEvent {
  const FetchUser();

  @override
  List<Object> get props => [];
}
