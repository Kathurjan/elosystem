import 'package:elosystem/screens/quizScreens/reusableQuizWidgets/answerDialog.dart';
import 'package:elosystem/screens/quizScreens/reusableQuizWidgets/answerList.dart';
import 'package:flutter/material.dart';

import '../../DTO/questionaireDTO.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import 'reusableQuizWidgets/dropDown.dart';
import 'reusableQuizWidgets/questionList.dart';

class QuizCreation extends StatefulWidget {
  const QuizCreation({Key? key}) : super(key: key);

  @override
  State<QuizCreation> createState() => _QuizCreationState();
}

class _QuizCreationState extends State<QuizCreation> {
  AuthService authService = AuthService.instance();
  Questionnaire questionaire = Questionnaire(quizQuestion: [], name: "", uId: "", weeklyQuiz: false, dailyQuiz: false);
  List<Map<String, bool>> _answers = [];
  bool _dropdownValue = false;
  bool editMode = false;

  final TextEditingController _QuestionController = TextEditingController();
  final TextEditingController _AnswerController = TextEditingController();



  void dropdownCallback(bool? selectedValue) {
    if (selectedValue is bool) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  editQuestionCall(int newIndex, context){ // Checks and dialog pop up to prevent missclicks
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Warning"),
              content: Text("Save your current question?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      questionCreation(context);
                      setState(() {
                        _answers = questionaire.quizQuestion[newIndex].answers;
                        editMode = true;
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                     setState(() {
                       _answers = questionaire.quizQuestion[newIndex].answers;
                       _QuestionController.clear();
                       _AnswerController.clear();
                       editMode = true;
                     });
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
              ],
            );
          });
    });
  }



  void questionCreation(BuildContext context){ // The method for creating questions based on the answer list
    num correctAnswers = 0;
    for (Map<String, bool> answer in _answers){
      if(answer.values.first == true){
        correctAnswers++;
      }
    }
    if(correctAnswers >= 1) {
      final quizAnswers = _answers.map((answer) {
        final answerText = answer.keys.first;
        final answerValue = answer.values.first == true;
        return <String, bool>{
          answerText: answerValue
        };
      }).toList();

      final quizQuestion = QuizQuestion(
        question: _QuestionController.text,
        answers: quizAnswers,
      );

      setState(() {
        questionaire.quizQuestion
            .add(quizQuestion);
      });

      _QuestionController.clear();
      _AnswerController.clear();
      _answers.clear();
    }
    else{
      setState(() {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text("You need atleast one correct answer"),
                actions: <Widget>[
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("ok"))
                ],
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) { // main body of the quiz creator
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container( // styling
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
              child: FutureBuilder<String>( // auth service
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
                    return Column( // main body
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Expanded( // Textfields and buttons
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: TextField(
                                      controller: _QuestionController,
                                      style: TextStyle(
                                          color: Colors.white.withAlpha(200)),
                                      enabled: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.question_mark,
                                          color: Colors.white60,
                                        ),
                                        labelText:
                                            "What question do you want to ask",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withAlpha(200)),
                                        filled: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        fillColor: Colors.white.withAlpha(50),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: TextField(
                                      controller: _AnswerController,
                                      style: TextStyle(
                                          color: Colors.white.withAlpha(200)),
                                      enabled: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.question_mark,
                                          color: Colors.white60,
                                        ),
                                        labelText:
                                            "Add an answer to the question",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withAlpha(200)),
                                        filled: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        fillColor: Colors.white.withAlpha(50),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.solid),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: DropDownButtonCustom(
                                        initialValue: _dropdownValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _dropdownValue = newValue;
                                          });
                                        },
                                      )),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _answers.add({
                                        _AnswerController.text: _dropdownValue
                                      });
                                    });
                                    _AnswerController.clear();
                                  },
                                  child: Text(
                                    "Add to list",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    questionCreation(context);
                                  },
                                  child: Text(
                                    "Finish the question",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    questionCreation(context);
                                  },
                                  child: Text(
                                    "Finish the questionaire",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: editMode ? const Text(
                                'In edit mode',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ) : null,
                          ),
                          Container( // List for both the answers and questions
                            height: 400,
                            child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    TabBar(
                                        tabs: [
                                          Tab(text: "Answer List"),
                                          Tab(text: "Question List")
                                        ]
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.white),
                                            ),
                                            child: AnswerList(answers: _answers),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.white),
                                            ),
                                            child: QuestionList(questions: questionaire.quizQuestion,
                                                onChanged: (int newIndex) {
                                                  setState(() {
                                                    if(_QuestionController.text.isNotEmpty && _answers.isNotEmpty) {
                                                      editQuestionCall(newIndex, context);
                                                    }
                                                    else{
                                                      _answers = questionaire.quizQuestion[newIndex].answers;
                                                      editMode = true;
                                                    }
                                                  });
                                                }),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ]);
                  }
                },
              ),
            )));
  }
}
