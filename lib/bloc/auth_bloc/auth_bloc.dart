import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../service/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService firebaseAuthService;
  AuthBloc({required this.firebaseAuthService}) : super(UnAuthenticated()) {
    on<GoogleSignInRequested>(_requestGoogleSignin);
    on<Authenticate>(_authenticate);
    on<SignOutRequested>(_requestSignout);
  }
  void _requestGoogleSignin(event, emit) async {
    emit(Loading());
    try {
      final firebaseUser = await firebaseAuthService.signInWithGoogle();
      emit(Authenticated(firebaseUser: firebaseUser));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  void _authenticate(Authenticate event, emit) async {
    emit(Authenticated(firebaseUser: event.firebaseUser));
  }

  void _requestSignout(event, emit) async {
    emit(Loading());
    await firebaseAuthService.signOut();
    emit(UnAuthenticated());
  }
}
