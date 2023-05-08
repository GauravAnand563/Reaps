import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/db_repo.dart';
import '../../service/flutter_toast.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final DatabaseRepository _repo;

  RegistrationBloc(this._repo) : super(Initial()) {
    on<FetchGrades>(_fetchGrades);
    on<FetchSubjectByGrade>(_fetchSubjectsByGrade);
    on<SubmitRegistration>(_submitRegistration);
  }
  void _fetchGrades(
    RegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(Loading());
    try {
      List<int>? grades = await _repo.getGrades();
      if (grades == null) {
        emit(const RegistrationError('Error fetching data'));
      } else {
        emit(GradesLoaded(grades: grades));
      }
    } catch (e) {
      emit(const RegistrationError('Unexpected error occurred'));
    }
  }

  void _fetchSubjectsByGrade(
    FetchSubjectByGrade event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(const SubjectsLoaded(subjects: []));
      emit(Loading());
      List<String>? subjects = await _repo.getSubjectsByGrade(event.grade);
      if (subjects == null) {
        emit(const RegistrationError('Error fetching data'));
      } else {
        if (subjects.isEmpty) {
          toast(text: 'Subjects not available for selected grade');
        }
        emit(SubjectsLoaded(subjects: subjects));
      }
    } catch (e) {
      emit(const RegistrationError('Unexpected error occurred'));
    }
  }

  void _submitRegistration(
    SubmitRegistration event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(Loading());
      final bool? result =
          await _repo.postRegistration(event.subjectPreferred, event.grade);
      if (result != null && result) {
        emit(RegistrationCompleted());
        toast(text: 'Successfully Registered');
      } else {
        emit(const RegistrationError('Error fetching data'));
      }
    } catch (e) {
      emit(const RegistrationError('Unexpected error occurred'));
    }
  }
}
