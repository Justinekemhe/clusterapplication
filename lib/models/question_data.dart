class QuestionData {
  final bool success;
  final List<Questions> questions;

  QuestionData({
    required this.success,
    required this.questions,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      success: json['success'] ?? false,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Questions.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

class Questions {
  final int id;
  final String question;
  final String feature;
  final List<Choices> choices;

  Questions({
    required this.id,
    required this.question,
    required this.feature,
    required this.choices,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      feature: json['feature'] ?? '',
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => Choices.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'feature': feature,
      'choices': choices.map((e) => e.toJson()).toList(),
    };
  }
}

class Choices {
  final int id;
  final String choice;

  Choices({
    required this.id,
    required this.choice,
  });

  factory Choices.fromJson(Map<String, dynamic> json) {
    return Choices(
      id: json['id'] ?? 0,
      choice: json['choice'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'choice': choice,
    };
  }
}
