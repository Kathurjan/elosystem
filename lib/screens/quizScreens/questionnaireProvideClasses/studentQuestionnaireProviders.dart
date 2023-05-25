import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../DTO/questionaireDTO.dart';
import '../../../utils/fire_service/auth_service.dart';
import '../../../utils/fire_service/questionairService.dart';
import '../../../utils/slideAnimation.dart';
import '../questionnaireViewScreen.dart';

class QuestionnaireSelectionProvider with ChangeNotifier {
  AuthService authService = AuthService.instance();
  Map<String, String>? dailyQuiz;
  Map<String, String>? weeklyQuiz;
  Questionnaire? questionnaire;
  bool isDailyQuizAvailable = false;
  bool isWeeklyQuizAvailable = false;



  Future<void> fetchDailyQuiz() async {
    dailyQuiz = await QuestionnaireService().getWeeklyOrDaily("dailyQuiz");
    dailyQuiz ??= {"": "Quiz not available"};
    isDailyQuizAvailable = dailyQuiz != null;
    notifyListeners();
  }

  Future<void> fetchWeeklyQuiz() async {
    weeklyQuiz = await QuestionnaireService().getWeeklyOrDaily("weeklyQuiz");
    weeklyQuiz ??= {"": "Quiz not available"};
    isWeeklyQuizAvailable = weeklyQuiz != null;
    notifyListeners();
  }

  Future<void> fetchSelectedQuestionnaire(String uId) async {
    questionnaire = await QuestionnaireService().getQuestionnaire(uId);
  }

  void navigateToQuizScreen(BuildContext context, String uId, String type) {
    print(uId);
    fetchSelectedQuestionnaire(uId);

    if (questionnaire != null) {
      Navigator.push(
        context,
        SlideAnimationRoute(
          child: QuestionnaireViewScreen(questionnaire: questionnaire!, type: type),
          slideRight: true,
        ),
      );
    }
  }

  QuestionnaireSelectionProvider(){
    fetchDailyQuiz();
    fetchWeeklyQuiz();

  }
}

class QuestionnaireViewProvider with ChangeNotifier {
  AuthService authService = AuthService.instance();
  Questionnaire questionnaire;
  String? type;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  late AnimationController _animationController;

  QuestionnaireViewProvider(this.questionnaire, this.type, tickerProvider ) {
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: 500),
    );
  }

  QuizQuestion get currentQuestion => questionnaire.quizQuestion[_currentQuestionIndex];

  int? get selectedAnswerIndex => _selectedAnswerIndex;

  void onAnswerSelected(int selectedAnswerIndex, BuildContext context) {
    if (questionnaire.quizQuestion[_currentQuestionIndex].answers[selectedAnswerIndex].values.first) {
      _score++;
    }

    if (_currentQuestionIndex < questionnaire.quizQuestion.length - 1) {
      _animationController.forward().then((_) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _animationController.reset();
        notifyListeners();
      });
    } else {
      // Quiz is over, show score
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Quiz finished'),
          content: Text(
            'Your score is $_score out of ${questionnaire.quizQuestion.length}, your extra score credit will only be added to your personal rating ONCE',
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                calculateScore();
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  void calculateScore() async {
    num pointPerQuestion = 20 / questionnaire.quizQuestion.length;
    int calcScore = (pointPerQuestion * _score).round();
    String? id = AuthService.instance().getCurrentUser()?.uid;
    String? questId = questionnaire.uId;

    if (id != null && type != null && questId != null) {
      await QuestionnaireService().addScoreFromQuiz(id, calcScore, type!, questId);
    }
  }
}
