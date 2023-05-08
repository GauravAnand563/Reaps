import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/db_repo.dart';
import '../../service/flutter_toast.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final DatabaseRepository _repo;

  FeedbackBloc(this._repo) : super(Initial()) {
    on<SubmitFeedback>(_submitFeedback);
  }

  void _submitFeedback(
    SubmitFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    try {
      emit(Loading());
      final bool? result =
          await _repo.postActivityFeedback(event.id, event.rating,event.feedback);
      if (result != null && result) {
        emit(FeedbackSubmitted());
        toast(text: 'Successfully Registered');
      } else {
        emit(const FeedbackError('Error fetching data'));
      }
    } catch (e) {
      emit(const FeedbackError('Unexpected error occurred'));
    }
  }
}
