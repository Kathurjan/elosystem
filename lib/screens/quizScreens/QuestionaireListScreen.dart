import 'package:elosystem/screens/quizScreens/quizCreationScreen.dart';
import 'package:elosystem/screens/quizScreens/quizScreen.dart';
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
  List<Map<String, String>>? listOfQuestionaires;

  Future<void> fetchQuestionnaires() async {
    listOfQuestionaires = await QuestionnaireService().getQuestionaireList();
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizCreation(),
                          ),
                        );
                      },
                      child: Text(
                        "Make a new questionnaire",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Container(
                      height: 400,
                      child: ListView.builder(
                          itemCount: listOfQuestionaires?.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (listOfQuestionaires == null || listOfQuestionaires!.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                    "No questionaires",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else {
                              final name =
                                  listOfQuestionaires?[index].values.first ?? "";
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Text(name),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: ()  {
                                                  setState(() {
                                                    listOfQuestionaires!.removeAt(index);
                                                    QuestionnaireService().removeQuestionnaire(listOfQuestionaires![index].keys.first);
                                                  });
                                                }),
                                        IconButton(
                                          onPressed: () async {
                                            await QuestionnaireService()
                                                .updateWeeklyOrDailyQuiz(
                                                    listOfQuestionaires![index]
                                                        .keys
                                                        .first,
                                                    "day");
                                          },
                                          icon: Icon(Icons.abc_outlined),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await QuestionnaireService()
                                                .updateWeeklyOrDailyQuiz(
                                                    listOfQuestionaires![index]
                                                        .keys
                                                        .first,
                                                    "week");
                                          },
                                          icon: Icon(Icons.abc_outlined),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.abc_outlined),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => QuizCreation(editUId: listOfQuestionaires![index].keys.first),
                                              ),
                                            );
                                          },
                                        ),
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
