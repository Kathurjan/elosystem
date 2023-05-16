import 'package:elosystem/screens/quizScreens/quizScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DTO/questionaireDTO.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/slideAnimation.dart';
import '../loginScreens/signin_screen.dart';

class QuizSelection extends StatefulWidget {
  const QuizSelection({Key? key}) : super(key: key);

  @override
  State<QuizSelection> createState() => _QuizSelectionState();
}

class _QuizSelectionState extends State<QuizSelection> {
  AuthService authService = AuthService.instance();
  Questionaire questionaire = new Questionaire(quizQuestion: [
    QuizQuestion(
        question: "question", answers: ["answers"], correctAnswerIndex: 0),
    QuizQuestion(
        question: "question",
        answers: ["answers", "lmao", "kek"],
        correctAnswerIndex: 3),
    QuizQuestion(
        question: "question",
        answers: ["answers", "lmao", "kek"],
        correctAnswerIndex: 2)
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return Stack(children: <Widget>[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: 0,
                        child: signOutButton("Sign out", context, () async {
                          AuthService authService = AuthService.instance();
                          try {
                            await authService.signOut();
                            Navigator.push(
                                context,
                                SlideAnimationRoute(
                                    child: const SignInScreen(),
                                    slideRight: true));
                          } catch (error) {
                            print("Error signing out: $error");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error signing out: $error")));
                          }
                        }),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.55,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              RoutingButton("Daily Quiz", context, () async {
                                Navigator.push(
                                    context,
                                    SlideAnimationRoute(
                                        child: QuizScreen(
                                            questionaire: questionaire),
                                        slideRight:
                                            true)); // Navigate to the screen after successful sign in
                              }),
                              const SizedBox(width: 10.0, height: 10.0),
                              RoutingButton("Weekly quiz", context, () async {
                                Navigator.push(
                                    context,
                                    SlideAnimationRoute(
                                        child: QuizScreen(
                                            questionaire: questionaire),
                                        slideRight:
                                            true)); // Navigate to the screen after successful sign in
                              }),
                              // RoutingButton("Quiz", "path"),
                            ],
                          )),
                    ]);
                  }
                },
              ),
            )));
  }
}
