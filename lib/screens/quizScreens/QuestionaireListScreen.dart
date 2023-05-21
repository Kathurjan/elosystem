import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/screens/quizScreens/quizCreationScreen.dart';
import 'package:elosystem/utils/fire_service/questionairService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/color_utils.dart';

class QuestionnaireListScreen extends StatefulWidget {
  const QuestionnaireListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionnaireListScreenState();
}

class _QuestionnaireListScreenState extends State<QuestionnaireListScreen> {
  AuthService authService = AuthService.instance();
  List<Map<String, String>> listOfQuestionaires = [];

  Future<void> fetchQuestionnaires() async {
    final questionnaires = await QuestionnaireService().getQuestionaireList();
    setState(() {
      listOfQuestionaires = questionnaires;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuestionnaires();
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
                        ).then((value) => {
                          if(value == true){
                            fetchQuestionnaires()
                          }
                        });
                      },
                      style: QuizeButtonStyle,
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
                        border: Border.all(color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid),
                      ),
                      height: 600,
                      child: ListView.builder(
                          itemCount: listOfQuestionaires.isNotEmpty ? listOfQuestionaires.length : 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (listOfQuestionaires.isEmpty) {
                              return  Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                    "No questionaires",
                                    style: TextStyle(color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  ),
                                ),
                              );
                            } else {
                              final name =
                                  listOfQuestionaires[index].values.first ?? "";
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    )
                                  )),
                                child: ListTile(
                                  title: Text(name, style: TextStyle(color: Colors.blue.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),),
                                  trailing: Container(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await QuestionnaireService()
                                                .updateWeeklyOrDailyQuiz(
                                                    listOfQuestionaires[index]
                                                        .keys
                                                        .first,
                                                    "dailyQuiz");
                                          },
                                          icon: Icon(Icons.calendar_view_day),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await QuestionnaireService()
                                                .updateWeeklyOrDailyQuiz(
                                                    listOfQuestionaires[index]
                                                        .keys
                                                        .first,
                                                    "weeklyQuiz");
                                          },
                                          icon: Icon(Icons.calendar_view_week),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => QuizCreation(editUId: listOfQuestionaires[index].keys.first),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: ()  {
                                              setState(() {
                                                QuestionnaireService().removeQuestionnaire(listOfQuestionaires[index].keys.first);
                                                listOfQuestionaires.removeAt(index);
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                );
              }
              // Add the remaining part of your code here
            },
          ),
        ),
      ),
    );
  }
}
