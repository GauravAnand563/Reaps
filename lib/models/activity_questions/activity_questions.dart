
import 'question.dart';

class ActivityQuestions {
  final List<Question> questions;


  const ActivityQuestions({
    required this.questions,
  });

  @override
  String toString() {
    return 'ActivityQuestions(questions: $questions,)';
  }

  factory ActivityQuestions.fromJson(Map<String, dynamic> json) {
    return ActivityQuestions(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'questions': questions.map((e) => e.toJson()).toList(),
      };
}
