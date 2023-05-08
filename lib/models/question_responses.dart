import 'activity_questions/question.dart';

class QuestionResponses {
  final List<QuestionResponse> questionResponses;

  const QuestionResponses({
    required this.questionResponses,
  });

  factory QuestionResponses.initial(List<Question> questions) {
    return QuestionResponses(
      questionResponses: questions
          .map((question) =>
              QuestionResponse(id: question.id, selectedOption: "-1"))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'QuestionResponses(questionResponsess: $questionResponses,)';
  }

  Map<String, dynamic> toJson() => {
        'questionResponsess': questionResponses.map((e) => e.toJson()).toList(),
      };
}

class QuestionResponse {
  final String id;
  final String selectedOption;

  const QuestionResponse({
    required this.id,
    required this.selectedOption,
  });

  @override
  String toString() {
    return 'QuestionResponse(id: $id,selectedOption: $selectedOption)';
  }

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionResponse(
      id: json['_id'] as String,
      selectedOption: json['selectedOption'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'selectedOption': selectedOption,
      };
}
