import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';
import '../cubits/activity_cubit/activity_cubit.dart';
import '../cubits/filter_cubit/filter_cubit.dart';
import 'activities.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../data/db_repo.dart';
import '../models/activity_data.dart';
import '../widgets/animatedDialog.dart';

import '../styles/app_theme_data.dart';
import '../widgets/frostedGlassButton.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  static String id = '/homePage';
  final UserData user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _getTopicTiles(activityState, Subject _subject, BuildContext context) {
    if (activityState.topics.length == 0) {
      return SliverToBoxAdapter(
        child: Column(children: [
          Image.asset("assets/images/ghost.gif"),
          Text(
            "No Topics to show!",
            style: kh3,
          ),
        ]),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return TopicTile(
            grade: _subject.grade,
            grades: activityState.grades,
            topic: activityState.topics[index],
            subject: _subject,
            subjects: activityState.subjects,
            topics: activityState.topics,
            thumbnail:
                "https://avatars.dicebear.com/api/bottts/fds${Random().nextInt(100)}.png");
      }, childCount: activityState.topics.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _filterState = BlocProvider.of<FilterCubit>(context).state;
    return SafeArea(
      child: Scaffold(
          backgroundColor: kScaffoldBackgroundColor,
          body: CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              const SliverAppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                expandedHeight: 100,
                flexibleSpace: HomePageHeader(),
              ),
              SliverToBoxAdapter(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const GradeCard()),
              ),
              const SliverToBoxAdapter(
                child: StatusCard(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text("Topics", style: kh1)),
              ),
              BlocBuilder<ActivityCubit, ActivityState>(
                builder: (context, activityState) {
                  if (activityState is GradesFetchError ||
                      activityState is GradesFetchSuccess ||
                      activityState is GradesFetchInProgress ||
                      activityState is SubjectsFetchError ||
                      activityState is SubjectsFetchInProgress ||
                      activityState is TopicsFetchInProgress) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  } else if (activityState is TopicsFetchError) {
                    return SliverToBoxAdapter(
                      child: Container(
                        child: const Text("Error fetching topics."),
                      ),
                    );
                  } else if (activityState is SubjectsFetchSuccess) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Container(
                          child: Text(
                            "No subject Selected!",
                            style: kh3,
                          ),
                        ),
                      ),
                    );
                  }
                  return BlocBuilder<FilterCubit, FilterState>(
                      builder: (context, filterState) {
                    if (filterState is GradeFilter) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                    return _getTopicTiles(
                        activityState, _getSubject(_filterState), context);
                  });
                },
              ),
            ],
          )),
    );
  }

  Subject _getSubject(filterState) {
    return filterState.subject;
  }
}

class GradeCard extends StatelessWidget {
  const GradeCard({Key? key}) : super(key: key);

  List<Widget> _getGrades(activityState, context) {
    List<Widget> gradeTiles = [];
    for (int i = 0; i < activityState.grades.length; i++) {
      gradeTiles.add(GradeTile(
        grade: activityState.grades[i],
        grades: activityState.grades,
      ));
    }
    return gradeTiles;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(builder: (context, state) {
      // print(state);
      if (state is GradesFetchError) {
        return const Text("Error fetching Grades.");
      } else if (state is GradesFetchInProgress) {
        return const Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grades',
              style: kh4.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: ListView.builder(
                itemCount: _getGrades(state, context).length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  return _getGrades(state, context)[index];
                }),
              ),
            ),
          ],
        );
      }
    });
  }
}

class GradeTile extends StatelessWidget {
  int grade;
  List<int>? grades;
  GradeTile({Key? key, required this.grade, required this.grades})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterState = BlocProvider.of<FilterCubit>(context).state;
    return InkWell(
      splashColor: kScaffoldBackgroundColor,
      onTap: () {
        BlocProvider.of<FilterCubit>(context).filterByGrade(grade);
        BlocProvider.of<ActivityCubit>(context).fetchSubjects(grade, grades);
      },
      child: Container(
        height: 50,
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: check(_filterState)
                ? const Color(0xff2E2F34)
                : Colors.greenAccent.withOpacity(0.8)),
        child: Center(
          child: Text(
            grade.toString(),
            style: kh3,
          ),
        ),
      ),
    );
  }

  bool check(state) {
    return state.grade != grade;
  }
}

class StatusCard extends StatefulWidget {
  const StatusCard({Key? key}) : super(key: key);

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  static late List<Subject> subjects;
  bool isExpanded = false;

  List<Widget> _getSubjects(List<Subject> subjects, List<int> grades) {
    List<Widget> subs = [];
    for (int i = 0; i < subjects.length; i++) {
      subs.add(SubjectChip(
        subject: subjects[i],
        subjects: subjects,
        grade: subjects[i].grade,
        grades: grades,
      ));
    }
    return subs;
  }

  Widget _getStatusCard(activityCardState) {
    subjects = activityCardState.subjects ?? [];
    final subjectWidgetsList = _getSubjects(subjects, activityCardState.grades);
    if (subjectWidgetsList.length == 0) {
      return Column(children: [
        Image.asset(
          "assets/images/ghost.gif",
          height: 80,
          width: 80,
        ),
        Text(
          "No Subjects to show!",
          style: kh3,
        ),
      ]);
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.greenAccent.shade100.withOpacity(0.3),
              blurRadius: 30)
        ],
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 78, 253, 151),
          Color(0xff06C0B5),
        ]),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // color: Colors.red,
                height: 75,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Choose Subject',
                      style: kh4.copyWith(fontWeight: FontWeight.w500),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.greenAccent,
                            child: Icon(
                              isExpanded
                                  ? CupertinoIcons.up_arrow
                                  : CupertinoIcons.down_arrow,
                              size: 18,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              isExpanded
                  ? Wrap(
                      spacing: 10, runSpacing: 10, children: subjectWidgetsList)
                  : Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                          width: 10,
                        ),
                        itemCount: subjects.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SubjectChip(
                            subject: subjects[index],
                            subjects: subjects,
                            grade: subjects[index].grade,
                            grades: activityCardState.grades,
                          );
                        },
                      ),
                    ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getStatusLoader() {
    return const Center(
      child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: Colors.greenAccent,
          )),
    );
  }

  Widget _getStatusError() {
    return const Center(
      child: Center(child: Text("Subject Fetch Error!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, activityCardState) {
        // print(activityCardState);
        if (activityCardState is SubjectsFetchInProgress ||
            activityCardState is GradesFetchInProgress ||
            activityCardState is GradesFetchError ||
            activityCardState is GradesFetchSuccess) {
          return _getStatusLoader();
        } else if (activityCardState is SubjectsFetchError) {
          return _getStatusError();
        }
        return _getStatusCard(activityCardState);
      },
    );
  }
}

class SubjectChip extends StatefulWidget {
  List<Subject>? subjects;
  List<int>? grades;
  int grade;
  Subject subject;
  SubjectChip(
      {Key? key,
      required this.subject,
      required this.subjects,
      required this.grade,
      required this.grades})
      : super(key: key);
  @override
  State<SubjectChip> createState() => _SubjectChipState();
}

class _SubjectChipState extends State<SubjectChip> {
  @override
  Widget _getSubjectChip(filterState) {
    return FrostedGlassButton(
      onTap: () {
        BlocProvider.of<ActivityCubit>(context)
            .fetchTopics(widget.subject.id!, widget.subjects, widget.grades);
        BlocProvider.of<FilterCubit>(context)
            .filterBySubject(widget.grade, widget.subject);
        // BlocProvider.of<ActivityCubit>(context).fetchSubjects(0);
      },
      text: widget.subject.name,
      color: widget.subject.id == filterState.subject.id
          ? Colors.greenAccent.shade400.withGreen(160)
          : Colors.black12,
    );
  }

  Widget _getSubjectChipWithoutSelected() {
    return FrostedGlassButton(
      onTap: () {
        BlocProvider.of<ActivityCubit>(context)
            .fetchTopics(widget.subject.id!, widget.subjects, widget.grades);
        BlocProvider.of<FilterCubit>(context)
            .filterBySubject(widget.grade, widget.subject);
        // BlocProvider.of<ActivityCubit>(context).fetchSubjects(0);
      },
      text: widget.subject.name,
      color: Colors.black12,
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        if (filterState is GradeFilter) {
          return _getSubjectChipWithoutSelected();
        }
        // } else {
        //   return FrostedGlassButton(
        //       onTap: () {
        //         BlocProvider.of<ActivityCubit>(context)
        //             .fetchTopics(widget.subject.id!, widget.subjects);
        //         BlocProvider.of<FilterCubit>(context)
        //             .filterBySubject(widget.subject);
        //         // BlocProvider.of<ActivityCubit>(context).fetchSubjects(0);
        //       },
        //       text: widget.subject.name,
        //       color: Colors.black12);
        // }
        return _getSubjectChip(filterState);
      },
    );
  }
}

class TopicTile extends StatelessWidget {
  TopicTile(
      {Key? key,
      required this.topic,
      required this.thumbnail,
      required this.subjects,
      required this.topics,
      required this.subject,
      required this.grade,
      required this.grades})
      : super(key: key);
  List<int>? grades;
  int grade;
  Topic topic;
  List<Subject>? subjects;
  Subject subject;
  List<Topic>? topics;
  String thumbnail;
  // final String topicName;
  // final String thumbnail;
  // final String description;
  // final String mentor;

  late OverlayEntry _popupDialog;

  OverlayEntry _createTopicPopup() {
    return OverlayEntry(
        builder: (context) => AnimatedDialog(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.greenAccent.shade100.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xff2E2F34)),
                          // child: Image.network(thumbnail),
                          child: Image.network(
                              "https://avatars.dicebear.com/api/bottts/fds${Random().nextInt(100)}.png"),
                        ),
                      ),
                      Text(
                        topic.title,
                        softWrap: true,
                        style: kh2.copyWith(fontSize: 16),
                      ),
                      Text(
                        "SEQ : " + topic.seq.toString() + " ID :" + topic.id,
                        softWrap: true,
                        style: kh3.copyWith(fontSize: 15),
                      ),
                      Text(
                        topic.subject.toString(),
                        softWrap: true,
                        style: ThemeData.light()
                            .textTheme
                            .overline!
                            .copyWith(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        // _logger.d(state);
        return BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, activityState) {
            // _logger.d(activityState);
            return GestureDetector(
              onLongPress: () {
                _popupDialog = _createTopicPopup();
                Overlay.of(context)?.insert(_popupDialog);
              },
              onLongPressEnd: (details) {
                _popupDialog.remove();
              },
              onTap: () {
                BlocProvider.of<ActivityCubit>(context)
                    .fetchActivities(topic.id, subjects, topics, grades);
                BlocProvider.of<FilterCubit>(context)
                    .filterByTopic(topic, subject, grade);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: ((_) => BlocProvider.value(
                        value: BlocProvider.of<ActivityCubit>(context),
                        child: BlocProvider.value(
                          value: BlocProvider.of<FilterCubit>(context),
                          child: const ActivitiesPage(),
                        ),
                      )),
                ));
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(20),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xff22262B).withOpacity(0.7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xff2E2F34)),
                              // child: Image.network(thumbnail),
                              child: Image.network(
                                  "https://avatars.dicebear.com/api/bottts/fds${Random().nextInt(100)}.png"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 160,
                              constraints:
                                  const BoxConstraints.tightForFinite(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    topic.title,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: kh2.copyWith(fontSize: 16),
                                  ),
                                  Text(
                                    "SEQ : " +
                                        topic.seq.toString() +
                                        " ID :" +
                                        topic.id,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: kh3.copyWith(fontSize: 15),
                                  ),
                                  Text(
                                    topic.subject.toString(),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: ThemeData.light()
                                        .textTheme
                                        .overline!
                                        .copyWith(
                                            color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.cyan,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Open in ',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500),
                              ),
                              const Icon(
                                CupertinoIcons.video_camera,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is Completed) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            alignment: Alignment.center,
            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              children: [
                Text(
                  'Hi, ',
                  style: kh4.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text(state.userData.firstName + "!",
                    style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.greenAccent,
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                              "https://avatars.dicebear.com/api/personas/fds${Random().nextInt(1000)}.png"),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text('Hi, User!');
        }
      },
    );
  }
}
