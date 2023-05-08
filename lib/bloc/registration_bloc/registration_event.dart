part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class FetchGrades extends RegistrationEvent {
  const FetchGrades();

  @override
  List<Object> get props => [];
}

class FetchSubjectByGrade extends RegistrationEvent {
  final int grade;

  const FetchSubjectByGrade(this.grade);

  @override
  List<int> get props => [grade];
}

class SubmitRegistration extends RegistrationEvent {
  final int grade;
  final String subjectPreferred;

  const SubmitRegistration(this.grade, this.subjectPreferred);

  @override
  List<Object> get props => [grade, subjectPreferred];
}

class UpdateDetails extends RegistrationEvent {
  @override
  List<Object> get props => [];
}
