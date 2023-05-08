// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yc_app/shared/custom_button.dart';
import 'package:yc_app/views/feedback.dart';
import '../models/question_responses.dart';
import '../styles/app_theme_data.dart';

class ResultPage extends StatelessWidget {
  static String id = '/resultPage';
  final QuestionResponses questionResponses;
  final String activityId;
  const ResultPage(
      {Key? key, required this.questionResponses, required this.activityId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
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
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.greenAccent.shade100.withOpacity(0.3),
                          blurRadius: 30)
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 78, 253, 151),
                        Color(0xff06C0B5),
                      ],
                    ),
                  ),
                  child: Image.asset('assets/images/ghost.gif'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    Text(
                      'Your response',
                      style: kh4,
                    ),
                    ShareTile(
                      icon: Icons.share,
                      onTap: () {
                        Share.share('Rank 1 on the activity.');
                      },
                    )
                  ],
                ),
              ),
              ...questionResponses.questionResponses
                  .map((qr) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Question Id ',
                                      style: kh4,
                                    )),
                                const SizedBox(
                                  height: 4,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Selection',
                                      style: kh4,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      qr.id,
                                      style: kh5,
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      qr.selectedOption,
                                      style: kh5,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              CustomButton(
                  buttonText: 'Submit Feedback',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => ActivityFeedbackScreen(
                                activityId: activityId,
                              )),
                    );
                  }),
                  const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShareTile extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  const ShareTile({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xff22262B).withOpacity(0.7),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff2E2F34)),
            child: Center(
              child: Icon(
                icon,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
