import 'option.dart';

class Question {
  final String id;
  final String? activity;
  final String question;
  final List<Option> options;
  final String correctOption;

  const Question({
    required this.id,
    this.activity,
    required this.question,
    required this.options,
    required this.correctOption,
  });

  @override
  String toString() {
    return 'Question(id: $id, activity: $activity, question: $question, options: $options, correctOption: $correctOption)';
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] as String,
      activity: json['activity'] as String?,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctOption: json['correctOption'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'activity': activity,
        'question': question,
        'options': options.map((e) => e.toJson()).toList(),
        'correctOption': correctOption,
      };
}
