import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yc_app/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:yc_app/configs/constants.dart';
import 'package:yc_app/models/rating_data.dart';
import 'package:yc_app/service/flutter_toast.dart';
import 'package:yc_app/shared/custom_button.dart';
import 'package:yc_app/shared/full_screen_loader.dart';
import 'package:yc_app/views/dashboard.dart';
import 'package:yc_app/widgets/custom_textfield.dart';
import 'package:yc_app/widgets/default_toolbar.dart';

class ActivityFeedbackScreen extends StatefulWidget {
  final String activityId;
  const ActivityFeedbackScreen({Key? key, required this.activityId}) : super(key: key);

  @override
  _ActivityFeedbackScreenState createState() => _ActivityFeedbackScreenState();
}

class _ActivityFeedbackScreenState extends State<ActivityFeedbackScreen> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController userFeedbackCtrl = TextEditingController();
  String userRating = 'Okay';
  double ratingValue = 3.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSubmitted) {
              toast(text: 'Feedback Submitted Successfully');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                  (_) => false);
            }
          },
          builder: (context, state) {
            return FullScreenLoader(
              isLoading: state is Loading,
              child: Column(
                children: [
                  const DefaultToolbar(
                    title: 'FeedBack',
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              const SizedBox(height: 11),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11.0),
                                child: SizedBox(
                                  child:
                                      Image.asset(AppAssetPaths.feedbackVector),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Rate your experience',
                                    textScaleFactor: 1.3,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 15),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    unratedColor: Colors.grey[200],
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 45,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, index) {
                                      final ratingData = getRatingData(index);
                                      return Icon(
                                        ratingData.ratingIcon,
                                        color: ratingData.ratingColor,
                                      );
                                    },
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        userRating =
                                            getRatingData(rating.ceil() - 1)
                                                .ratingText;
                                        ratingValue = rating;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(userRating,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: getRatingData(
                                                  ratingValue.ceil() - 1)
                                              .ratingColor,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  CustomTextField(
                                    label: 'Tell us about your experience',
                                    controller: userFeedbackCtrl,
                                    minLines: 5,
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return "Feedback field can't be empty";
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomButton(
                                onTap: () {
                                  setState(() {
                                    if (_formKey.currentState!.validate()) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      BlocProvider.of<FeedbackBloc>(context)
                                          .add(SubmitFeedback(
                                              widget.activityId,
                                              userRating,
                                              userFeedbackCtrl.text.trim()));
                                    }
                                  });
                                },
                                buttonText: 'Submit',
                                isPadded: true,
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  RatingData getRatingData(int index) {
    switch (index) {
      case 0:
        return RatingData(
          ratingIcon: Icons.sentiment_very_dissatisfied,
          ratingColor: Colors.red,
          ratingText: 'Poor',
        );
      case 1:
        return RatingData(
          ratingIcon: Icons.sentiment_dissatisfied,
          ratingColor: Colors.orange,
          ratingText: 'Bad',
        );
      case 2:
        return RatingData(
          ratingIcon: Icons.sentiment_neutral,
          ratingColor: Colors.amber,
          ratingText: 'Okay',
        );
      case 3:
        return RatingData(
          ratingIcon: Icons.sentiment_satisfied,
          ratingColor: Colors.lightGreen,
          ratingText: 'Good',
        );
      case 4:
        return RatingData(
          ratingIcon: Icons.sentiment_very_satisfied,
          ratingColor: Colors.green,
          ratingText: 'Amazing',
        );
      default:
        return RatingData(
            ratingIcon: Icons.error,
            ratingColor: Colors.red,
            ratingText: 'Error');
    }
  }
}
