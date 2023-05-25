import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/screens/quizScreens/questionnaireProvideClasses/teacherQuestionnaireProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/color_utils.dart';
import '../../utils/fire_service/questionairService.dart';

class QuestionnaireListScreen extends StatefulWidget {
  const QuestionnaireListScreen({Key? key}) : super(key: key);

  @override
  _QuestionnaireListScreenState createState() => _QuestionnaireListScreenState();
}

class _QuestionnaireListScreenState extends State<QuestionnaireListScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuestionnaireListState(),
      child: Consumer<QuestionnaireListState>(builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Questionnaire list'),
            backgroundColor: hexStringToColor("fdbb2d"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back button press
                Navigator.pop(context);
              },
            ),
          ),
          resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      state.goToQuestionaireCreation(null, context);
                    },
                    style: QuizButtonStyle,
                    child: Text(
                      "Make a new questionnaire",
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: StreamBuilder<List<Map<String, String>>>(
                      stream: state.questionnairesStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<Map<String, String>> questionnaires = snapshot.data ?? [];
                          if (questionnaires.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text(
                                  "No questionnaires",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: questionnaires.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final name = questionnaires[index].values.first ?? "";
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        name,
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await QuestionnaireService().updateWeeklyOrDailyQuiz(
                                                  questionnaires[index].keys.first,
                                                  "dailyQuiz",
                                                );
                                              },
                                              icon: Icon(Icons.calendar_view_day),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                await QuestionnaireService().updateWeeklyOrDailyQuiz(
                                                  questionnaires[index].keys.first,
                                                  "weeklyQuiz",
                                                );
                                              },
                                              icon: Icon(Icons.calendar_view_week),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                state.goToQuestionaireCreation(questionnaires[index].values.first, context);
                                              },
                                              icon: Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                state.removeQuestionnaire(questionnaires[index].keys.first);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
