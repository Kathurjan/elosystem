import 'package:elosystem/screens/quizScreens/questionnaireProvideClasses/studentQuestionnaireProviders.dart';
import 'package:elosystem/screens/quizScreens/questionnaireViewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';


class QuestionnaireSelectionScreen extends StatefulWidget {
  const QuestionnaireSelectionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireSelectionScreen> createState() => _QuestionnaireSelectionScreenState();
}


class _QuestionnaireSelectionScreenState extends State<QuestionnaireSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionnaireSelectionProvider(),
      child: Consumer<QuestionnaireSelectionProvider>(builder: (context, state, _) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            backgroundColor: hexStringToColor("fdbb2d"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
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
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.30,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 350,
                              child: ElevatedButton(
                                onPressed: state.isDailyQuizAvailable
                                    ? () => state.navigateToQuizScreen(
                                    context,
                                    state.dailyQuiz!.keys.last,
                                    "day")
                                    : null,
                                style: QuizButtonStyle,
                                child: Text(
                                  "Daily Quiz: ${state.dailyQuiz != null ? state.dailyQuiz!.values.first : 'Quiz not available'}",
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0, height: 10.0),
                            SizedBox(
                              width: 350,
                              child: ElevatedButton(
                                onPressed: state.isWeeklyQuizAvailable
                                    ? () => state.navigateToQuizScreen(
                                    context,
                                    state.weeklyQuiz!.keys.first,
                                    "week")
                                    : null,
                                style: QuizButtonStyle,
                                child: Text(
                                  "Weekly Quiz: ${state.weeklyQuiz != null ? state.weeklyQuiz!.values.first : 'Quiz not available'}",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              )
          )
      );
    })
    );



  }
}