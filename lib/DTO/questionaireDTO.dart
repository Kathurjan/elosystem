class Questionaire {
  List<QuizQuestion> quizQuestion = [];

  Questionaire({required this.quizQuestion});
}

class QuizQuestion {
  final String question;
  final List<Map<String, bool>> answers;
  QuizQuestion({required this.question, required this.answers});
}

