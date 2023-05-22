import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/screens/quizScreens/quizCreationScreen.dart';
import 'package:elosystem/utils/fire_service/questionairService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/fire_service/auth_service.dart';
import '../../utils/color_utils.dart';


class QuestionnaireListProvider extends StatelessWidget {
  final Widget child;

  const QuestionnaireListProvider({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuestionnaireListState(),
      child: child,
    );
  }
}

class QuestionnaireListScreen extends StatefulWidget {
  const QuestionnaireListScreen({Key? key}) : super(key: key);

  @override
  _QuestionnaireListScreenState createState() => _QuestionnaireListScreenState();
}

class _QuestionnaireListScreenState extends State<QuestionnaireListScreen> {
  @override
  void initState() {
    super.initState();
    final questionnaireListState = Provider.of<QuestionnaireListState>(context, listen: false);
    questionnaireListState.fetchQuestionnaires();
  }

  @override
  Widget build(BuildContext context) {
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
      resizeToAvoidBottomInset: false,
      body: Container(
        // Styling
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
          child: FutureBuilder<String>(
            future: Provider.of<AuthService>(context).getCurrentUserName(),
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
                final questionnaireListState = Provider.of<QuestionnaireListState>(context);
                return Consumer<QuestionnaireListState>(
                  builder: (context, state, _) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizCreation(),
                              ),
                            ).then((value) {
                              if (value == true) {
                                state.fetchQuestionnaires();
                              }
                            });
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          height: 600,
                          child: ListView.builder(
                            itemCount: state.listOfQuestionnaires.isNotEmpty ? state.listOfQuestionnaires.length : 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.listOfQuestionnaires.isEmpty) {
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
                                final name = state.listOfQuestionnaires[index].values.first ?? "";
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
                                                state.listOfQuestionnaires[index].keys.first,
                                                "dailyQuiz",
                                              );
                                            },
                                            icon: Icon(Icons.calendar_view_day),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await QuestionnaireService().updateWeeklyOrDailyQuiz(
                                                state.listOfQuestionnaires[index].keys.first,
                                                "weeklyQuiz",
                                              );
                                            },
                                            icon: Icon(Icons.calendar_view_week),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => QuizCreation(
                                                    editUId: state.listOfQuestionnaires[index].keys.first,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              state.removeQuestionnaire(state.listOfQuestionnaires[index].keys.first);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class QuestionnaireListState with ChangeNotifier {
  List<Map<String, String>> listOfQuestionnaires = [];

  Future<void> fetchQuestionnaires() async {
    final questionnaires = await QuestionnaireService().getQuestionaireList();
    listOfQuestionnaires = questionnaires;
    notifyListeners();
  }

  void removeQuestionnaire(String questionnaireId) {
    QuestionnaireService().removeQuestionnaire(questionnaireId);
    listOfQuestionnaires.removeWhere((map) => map.containsKey(questionnaireId));
    notifyListeners();
  }
}