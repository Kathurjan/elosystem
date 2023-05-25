class Questionnaire {
  List<QuizQuestion> quizQuestion = [];
  final bool weeklyQuiz;
  final bool dailyQuiz;
  String ?uId;
  String ?name;

  Questionnaire({required this.quizQuestion, required this.dailyQuiz, required this.weeklyQuiz, this.uId, this.name});
}

class QuizQuestion {
  final String question;
  final List<Map<String, bool>> answers;
  QuizQuestion({required this.question, required this.answers});
}

