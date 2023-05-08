import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yc_app/bloc/registration_bloc/registration_bloc.dart'
    as register;
import 'package:yc_app/data/db_repo.dart';
import 'package:yc_app/models/user_data.dart';
import 'package:yc_app/views/result.dart';
import '../bloc/auth_bloc/auth_bloc.dart' as auth;
import '../bloc/user_bloc/user_bloc.dart';
import '../cubits/activity_cubit/activity_cubit.dart';
import '../cubits/filter_cubit/filter_cubit.dart';
import '../models/activity_data.dart';
import '../styles/app_colors.dart';
import 'home.dart';
import 'login/login_screen.dart';
import '../widgets/default_toolbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseRepository _repository = DatabaseRepository();
  late List<Subject>? subjects;
  late List<int>? grades;
  late UserData userData;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ActivityCubit>(context).fetchGrades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is Loading) {
            return _getLoader();
          }
          if (state is Completed) {
            userData = state.userData;
            return FutureBuilder(
                future: _getSubjects(userData),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Subject Fetch Error'),
                    );
                  } else if (snapshot.hasData) {
                    final subjectPreferred = subjects!
                        .where((element) =>
                            (element.name == userData.subjectPreferred))
                        .toList()[0];
                    // print(grades);
                    BlocProvider.of<ActivityCubit>(context)
                        .fetchTopics(subjectPreferred.id!, subjects, grades);
                    return BlocProvider<FilterCubit>(
                      create: (context) => FilterCubit(
                          subjectPreferred: subjectPreferred,
                          grade: userData.grade),
                      child: HomePage(user: userData),
                    );
                  } else {
                    return _getLoader();
                  }
                }));
          }
          return const Center(child: Text('Error'));
        },
      ),
    );
  }

  Widget _getLoader() {
    return const Center(
        child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            )));
  }

  Future<List<Subject>?> _getSubjects(userData) async {
    subjects = await _repository.getSubjects(userData.grade!);
    grades = await _repository.getGrades();
    return subjects;
  }
}
