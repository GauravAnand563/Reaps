import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/db_repo.dart';
import '../../models/activity_questions/activity_questions.dart';
import '../../models/question_responses.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final DatabaseRepository _repo;
  late ActivityQuestions? activityQuestions;
  late QuestionResponses questionResponses;

  QuizBloc(this._repo) : super(Loading()) {
    on<FetchQuestions>(_fetchQuestions);
    on<MarkOption>(_markOption);
  }
  void _fetchQuestions(FetchQuestions event, Emitter<QuizState> emit) async {
    emit(Loading());
    try {
      activityQuestions = await _repo.getQuestionsByActivity(event.activityId);

      if (activityQuestions == null) {
        emit(const QuizError('Error fetching user'));
      } else {
        questionResponses =
            QuestionResponses.initial(activityQuestions!.questions);
        emit(Loaded(
            activityQuestions: activityQuestions!,
            questionResponses: questionResponses));
      }
    } catch (e) {
      emit(const QuizError('Unexpected error occurred'));
    }
  }

  void _markOption(MarkOption event, Emitter<QuizState> emit) async {
    String qId = event.questionId;
    String key = event.optionKey;

    final updatedQResponses =
        questionResponses.questionResponses.map((qResponse) {
      if (qResponse.id == qId) {
        return QuestionResponse(id: qId, selectedOption: key);
      }
      return qResponse;
    }).toList();
    questionResponses = QuestionResponses(questionResponses: updatedQResponses);
    emit(
      Loaded(
          activityQuestions: activityQuestions!,
          questionResponses: questionResponses),
    );
  }
}
