import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yc_app/views/result.dart';
import '../../bloc/quiz_bloc/quiz_bloc.dart';
import '../../shared/custom_button.dart';
import '../../styles/app_colors.dart';
import 'question_widget.dart';
import '../../widgets/default_toolbar.dart';

class QuestionScreen extends StatefulWidget {
  final String activityId;
  const QuestionScreen({Key? key, required this.activityId}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    BlocProvider.of<QuizBloc>(context).add(FetchQuestions(widget.activityId));
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
            const DefaultToolbar(
              title: 'Quiz',
              showBackButton: true,
            ),
            BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
              if (state is Loading) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (state is Loaded) {
                final activityQuestions = state.activityQuestions.questions;
                final questionResponses = state.questionResponses;
                if (activityQuestions.isEmpty) {
                  return const Expanded(
                      child: Center(
                          child: Text('Quiz unavailable for this activity')));
                }
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Question ${currentPageIndex + 1}/${activityQuestions.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColors.secondary400),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: PageView(
                            controller: _pageController,
                            onPageChanged: ((value) => setState(() {
                                  currentPageIndex = value;
                                })),
                            children: activityQuestions
                                .map((question) => QuestionWidget(
                                      question: question,
                                      qResponse: questionResponses
                                          .questionResponses
                                          .firstWhere(
                                        (qr) => qr.id == question.id,
                                      ),
                                    ))
                                .toList()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: currentPageIndex > 0
                                  ? CustomButton(
                                      isPadded: true,
                                      buttonText: 'Previous',
                                      onTap: () {
                                        _pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeOut,
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: currentPageIndex <
                                      activityQuestions.length - 1
                                  ? CustomButton(
                                      isPadded: true,
                                      buttonText: 'Next',
                                      onTap: () {
                                        _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                    )
                                  : CustomButton(
                                      isPadded: true,
                                      buttonText: 'Submit',
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResultPage(
                                                      questionResponses:
                                                          questionResponses,
                                                          activityId: widget.activityId,
                                                    )));
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('Error'));
            }),
          ],
        ),
      ),
    );
  }
}
