import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../models/user_data.dart';
import '../dashboard.dart';
import 'login_screen.dart';
import 'user_details_screen.dart';

class UserStatusWrapper extends StatefulWidget {
  final User firebaseUser;
  const UserStatusWrapper({Key? key, required this.firebaseUser})
      : super(key: key);
  @override
  State<UserStatusWrapper> createState() => _UserStatusWrapperState();
}

class _UserStatusWrapperState extends State<UserStatusWrapper> {
  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(RegisterUser(UserData(
      firstName: widget.firebaseUser.displayName?.split(' ')[0] ?? '',
      lastName: widget.firebaseUser.displayName?.split(' ')[1] ?? '',
      email: widget.firebaseUser.email ?? '',
    )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is Loading || state is Initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is Pending) {
            return UserDetailsScreen(userData: state.userData);
          }
          if (state is Completed) {
            return const Dashboard();
          }
          return InkWell(
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  ),
              child: const Text('Errorrrrr'));
        },
      ),
    );
  }
}
