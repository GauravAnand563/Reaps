// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yc_app/styles/app_theme_data.dart';
import 'package:yc_app/views/video.dart';

import '../cubits/activity_cubit/activity_cubit.dart';
import '../cubits/filter_cubit/filter_cubit.dart';
import '../models/activity_data.dart';
import '../widgets/animatedDialog.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  List<Widget> getActivitiesList(
      activityState, topic, subject, grade, BuildContext context) {
    List<Widget> activities = [];
    if (activityState.activities.length == 0) {
      activities.add(
        Column(children: [
          Image.asset("assets/images/ghost.gif"),
          Text(
            "No activities to show!",
            style: kh3,
          ),
        ]),
      );
      return activities;
    }
    for (int i = 0; i < activityState.activities.length; i++) {
      activities.add(ActivityTile(
        activity: activityState.activities[i],
        topic: topic,
        subject: subject,
        grade: grade,
      ));
    }
    return activities;
  }

  Widget _getActivities(activityState, filterState, context) {
    return Wrap(
        children: getActivitiesList(
            activityState,
            _getChosenSubject(filterState),
            _getChosenTopic(filterState),
            _getChosenGrade(filterState),
            context));
  }

  Topic _getChosenTopic(filterState) {
    return filterState.topic;
  }

  Subject _getChosenSubject(filterState) {
    return filterState.subject;
  }

  int _getChosenGrade(filterState) {
    return filterState.grade;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Text("Activities", style: kh1),
              BlocBuilder<FilterCubit, FilterState>(
                builder: (context, filterState) {
                  return BlocBuilder<ActivityCubit, ActivityState>(
                    builder: (context, activityState) {
                      // print(activityState);
                      if (activityState is ActivitiesFetchSuccess) {
                        return Wrap(
                            children: getActivitiesList(
                                activityState,
                                _getChosenTopic(filterState),
                                _getChosenSubject(filterState),
                                _getChosenGrade(filterState),
                                context));
                      } else if (activityState is ActivitiesFetchError) {
                        return Container(
                          child: Text("Error loading activities."),
                        );
                      }
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 80),
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            color: Colors.green.shade100,
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  ActivityTile({
    Key? key,
    required this.activity,
    required this.topic,
    required this.subject,
    required this.grade,
  }) : super(key: key);

  final Activity activity;
  final Topic topic;
  final Subject subject;
  final int grade;
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
                    color: Colors.cyan.shade100.withOpacity(0.3),
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
                              color: Colors.white12),
                          // child: Image.network(thumbnail),
                          child: Image.asset("assets/images/ghost.gif"),
                        ),
                      ),
                      Text(
                        activity.name,
                        softWrap: true,
                        style: kh2.copyWith(fontSize: 16),
                      ),
                      Text(
                        activity.description,
                        softWrap: true,
                        style: kh3.copyWith(fontSize: 15),
                      ),
                      Text(
                        activity.videoUrl,
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
                BlocProvider.of<FilterCubit>(context)
                    .filterByActivity(activity, topic, subject, grade);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoPage(activity: activity)));
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
                                    activity.name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: kh2.copyWith(fontSize: 16),
                                  ),
                                  Text(
                                    activity.description,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: kh3.copyWith(fontSize: 15),
                                  ),
                                  Text(
                                    activity.videoUrl,
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
                        color: Colors.greenAccent.shade100,
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
