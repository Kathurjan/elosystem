class Questionnaire {
  List<QuizQuestion> quizQuestion = [];
  final bool weeklyQuiz;
  final bool dailyQuiz;
  final String uId;
  final String name;

  Questionnaire({required this.quizQuestion, required this.dailyQuiz, required this.weeklyQuiz, required this.uId, required this.name});
}

class QuizQuestion {
  final String question;
  final List<Map<String, bool>> answers;
  QuizQuestion({required this.question, required this.answers});
}

