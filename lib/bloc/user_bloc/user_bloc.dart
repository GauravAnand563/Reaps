import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/db_repo.dart';
import '../../models/user_data.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseRepository _repo;

  UserBloc(this._repo) : super(Initial()) {
    on<RegisterUser>(_registerUser);
    on<FetchUser>(_fetchUser);
  }
  void _registerUser(RegisterUser event, Emitter<UserState> emit) async {
    emit(Loading());
    try {
      UserData? userData = await _repo.registerInitialUser(event.userData);
      if (userData == null) {
        emit(const UserError('Error registering user'));
      } else {
        if (userData.isRegistrationCompleted) {
          emit(Completed(userData: userData));
        } else {
          emit(Pending(userData: userData));
        }
      }
    } catch (e) {
      emit(const UserError('Unexpected error occurred'));
    }
  }

  void _fetchUser(FetchUser event, Emitter<UserState> emit) async {
    emit(Loading());
    try {
      UserData? userData = await _repo.fetchUser();
      if (userData == null) {
        emit(const UserError('Error registering user'));
      } else {
        if (userData.isRegistrationCompleted) {
          emit(Completed(userData: userData));
        } else {
          emit(Pending(userData: userData));
        }
      }
    } catch (e) {
      emit(const UserError('Unexpected error occurred'));
    }
  }
}
