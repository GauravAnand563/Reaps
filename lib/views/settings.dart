import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login/user_details_screen.dart';
import 'login/user_status_wrapper.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../styles/app_theme_data.dart';
import 'login/login_screen.dart';

class SettingsPage extends StatelessWidget {
  static String id = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is Completed) {
                final userData = state.userData;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 20, bottom: 20),
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              CupertinoIcons.arrow_left,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return UserDetailsScreen(userData: userData);
                            }), (route) => false);
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                const Color(0xff22262B).withOpacity(0.7),
                            child: const Icon(
                              Icons.mode_edit_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Colors.greenAccent.shade100.withOpacity(0.3),
                              blurRadius: 30)
                        ],
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 78, 253, 151),
                          Color(0xff06C0B5),
                        ]),
                      ),
                      child: Image.network(
                          "https://avatars.dicebear.com/api/personas/fds${Random().nextInt(100)}.png"),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff22262B).withOpacity(0.7)),
                      child: Column(
                        children: [
                          Text(
                            userData.firstName + " " + userData.lastName,
                            style: kh4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Chip(
                                backgroundColor: Colors.greenAccent.shade200,
                                label: Text(
                                  "Grade : " + userData.grade.toString(),
                                  style: kh3.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black),
                                ),
                                avatar: const Icon(
                                  Icons.school,
                                  color: Colors.white70,
                                ),
                              ),
                              Chip(
                                backgroundColor: const Color(0xff06C0B5),
                                label: Text(
                                  userData.subjectPreferred!,
                                  style: kh3.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black),
                                ),
                                avatar: const Icon(
                                  Icons.star_border_purple500_rounded,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            userData.email,
                            style: kh3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.redAccent.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        child: Text(
                          'Sign Out',
                          style: kh4,
                        ),
                        onTap: () => BlocProvider.of<AuthBloc>(context)
                            .add(SignOutRequested()),
                      ),
                    )
                  ],
                );
              }
              return const Center(
                child: Text('Setting Page Error'),
              );
            },
          ),
        ),
      ),
    );
  }
}
