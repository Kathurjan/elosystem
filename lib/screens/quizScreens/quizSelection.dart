import 'package:elosystem/screens/quizScreens/quizScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../DTO/questionaireDTO.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/fire_service/questionairService.dart';
import '../../utils/slideAnimation.dart';
import '../loginScreens/signin_screen.dart';

class QuizSelection extends StatefulWidget {
  const QuizSelection({Key? key}) : super(key: key);

  @override
  State<QuizSelection> createState() => _QuizSelectionState();
}

class _QuizSelectionState extends State<QuizSelection> {
  AuthService authService = AuthService.instance();

  Map<String, String>? dailyQuiz;
  Map<String, String>? weeklyQuiz;
  Questionnaire? questionnaire;

  Future<void> fetchDailyQuiz() async {
    dailyQuiz = await QuestionnaireService().getWeeklyOrDaily("dailyQuiz");
    weeklyQuiz = await QuestionnaireService().getWeeklyOrDaily("weeklyQuiz");

    dailyQuiz ??= {"": "Quiz not available"};
    weeklyQuiz ??= {"": "Quiz not available"};
  }

  Future<void> fetchSelectedQuestionaire(String uId) async {
    questionnaire = await QuestionnaireService().getQuestionnaire(uId);
  }

  @override
  void initState() {
    super.initState();
    fetchDailyQuiz();
  }

  void navigateToQuizScreen(String uId) {
    fetchSelectedQuestionaire(uId);
    if (questionnaire != null) {
      Navigator.push(
        context,
        SlideAnimationRoute(
          child: QuizScreen(questionnaire: questionnaire!),
          slideRight: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDailyQuizAvailable = dailyQuiz != null;
    bool isWeeklyQuizAvailable = weeklyQuiz != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: hexStringToColor("fdbb2d"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("fdbb2d"),
              hexStringToColor("22c1c3"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 00.0, right: 00.0),
          child: FutureBuilder<String>(
            future: authService.getCurrentUserName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.55,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          IgnorePointer(
                            ignoring: !isDailyQuizAvailable,
                            child: RoutingButton(
                              "Daily Quiz: ${dailyQuiz != null ? dailyQuiz!.values.first : 'Quiz not available'}",
                              context,
                                  () => navigateToQuizScreen(dailyQuiz!.keys.last),
                            ),
                          ),
                          const SizedBox(width: 10.0, height: 10.0),
                          IgnorePointer(
                            ignoring: !isWeeklyQuizAvailable,
                            child: RoutingButton(
                              "Weekly Quiz: ${weeklyQuiz != null ? weeklyQuiz!.values.first : 'Quiz not available'}",
                              context,
                                  () => navigateToQuizScreen(weeklyQuiz!.keys.first),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}