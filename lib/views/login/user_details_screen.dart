import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart' as auth;
import '../../bloc/registration_bloc/registration_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart' as userBloc;
import '../../models/user_data.dart';
import '../../service/flutter_toast.dart';
import '../../shared/custom_button.dart';
import '../../shared/full_screen_loader.dart';
import '../../styles/app_colors.dart';
import '../../utils/logger.dart';
import '../dashboard.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/default_toolbar.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserData userData;
  const UserDetailsScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<int> grades = [];
  List<String> subjects = [];
  int? grade;
  String? subjectPreferred;
  @override
  void initState() {
    BlocProvider.of<RegistrationBloc>(context).add(const FetchGrades());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultToolbar(
              title: 'User Details',
              trailing: InkWell(
                onTap: () => BlocProvider.of<auth.AuthBloc>(context)
                    .add(auth.SignOutRequested()),
                child: const Icon(
                  Icons.logout,
                  color: AppColors.accent100,
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<RegistrationBloc, RegistrationState>(
                listener: (context, state) {
                  if (state is RegistrationCompleted) {
                    BlocProvider.of<userBloc.UserBloc>(context)
                        .add(const userBloc.FetchUser());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GradesLoaded) {
                    grades = state.grades;
                  }

                  if (state is SubjectsLoaded) {
                    subjects = state.subjects;
                  }
                  return FullScreenLoader(
                    isLoading: state is Loading,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Hello ${widget.userData.firstName}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          CustomDropdown(
                            items: grades.map((e) => e.toString()).toList(),
                            hintText: 'Select your grade',
                            onSaved: ((newValue) {
                              grade =
                                  newValue != null ? int.parse(newValue) : null;
                              if (grade != null) {
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(FetchSubjectByGrade(grade!));
                              }
                            }),
                          ),
                          CustomDropdown(
                            items: subjects,
                            hintText: 'Select subjectPreferred preference',
                            onSaved: (newValue) {
                              subjectPreferred = newValue;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            buttonText: 'Submit',
                            onTap: () {
                              logger
                                  .d('Grade $grade\nSubject $subjectPreferred');
                              if (grade != null && subjectPreferred != null) {
                                BlocProvider.of<RegistrationBloc>(context).add(
                                    SubmitRegistration(
                                        grade!, subjectPreferred!));
                              } else if (grade == null) {
                                toast(text: 'Please select a grade');
                              } else if (subjectPreferred == null) {
                                toast(text: 'Please select a subject');
                              }
                            },
                            isPadded: true,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )));
  }
}
