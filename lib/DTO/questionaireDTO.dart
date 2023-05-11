class Questionaire {
  List<QuizQuestion> quizQuestion = [];

  Questionaire({required this.quizQuestion});
}

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  QuizQuestion({required this.question, required this.answers, required this.correctAnswerIndex});
}

