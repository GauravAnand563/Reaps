// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:yc_app/customVideoPlayer/customVideoPlayer.dart';
import 'package:yc_app/customVideoPlayer/customVideoPlayerController.dart';
import 'package:yc_app/models/activity_questions/question.dart';
import 'package:yc_app/styles/app_theme_data.dart';
import 'package:yc_app/views/quiz/question_screen.dart';
import 'package:yc_app/views/result.dart';
import 'package:yc_app/widgets/frostedGlassButton.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/activity_data.dart';

class VideoPage extends StatefulWidget {
  final Activity activity;
  const VideoPage({Key? key, required this.activity}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Widget? _child;
  late YoutubePlayerController _controller;
  late VideoPlayerController videoPlayerController;
  late LivePreviewPlayerController _livePreviewPlayerController;

  String thumbnailUrl = "https://picsum.photos/200/200";
  @override
  void initState() {
    super.initState();
    // _setupLivePreviewPlayer();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.activity.videoUrl)!,
    );
  }

  void _setupLivePreviewPlayer() {
    videoPlayerController =
        VideoPlayerController.network(widget.activity.videoUrl)
          ..initialize().then((value) => setState(() {}));
    _livePreviewPlayerController = LivePreviewPlayerController(
        context: context, videoPlayerController: videoPlayerController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _child = LivePreviewPlayer(
              livePreviewPlayerController: _livePreviewPlayerController);
          _livePreviewPlayerController.videoPlayerController.play();
        });
      });
    });
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // _livePreviewPlayerController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: kScaffoldBackgroundColor,
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: CustomFloatingActionButton(
              function: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  QuestionScreen(activityId:widget.activity.id,)));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                // _getLivePreviewPlayer(),
                player,
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(widget.activity.name,
                              style: kh1.copyWith(fontSize: 25))),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.activity.description,
                        style: kh4,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      VideoDetailsTile(
                        icon: Icons.link_rounded,
                        text: widget.activity.videoUrl,
                      ),
                      VideoDetailsTile(
                        icon: Icons.tag,
                        text: "SEQ : " + widget.activity.seq.toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget _getLivePreviewPlayer() {
    return Center(
      child: _child ??
          Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return Container(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.all(10),
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.greenAccent.shade100.withOpacity(0.3),
                            blurRadius: 30)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: child);
              }
              return Container(
                constraints: BoxConstraints.tight(Size(50, 50)),
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            },
          ),
    );
  }
}

class VideoDetailsTile extends StatelessWidget {
  IconData icon;
  String text;
  VideoDetailsTile({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(20),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xff22262B).withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xff2E2F34)),
                // child: Image.network(thumbnail),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 18,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: kh2.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  Function? function;
  CustomFloatingActionButton({
    Key? key,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function!();
      },
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.greenAccent.shade100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.sports_esports,
              color: Colors.green,
              size: 30,
            ),
            Text(
              "Take Quiz",
              style: kh4.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
