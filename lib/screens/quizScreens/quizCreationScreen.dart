import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/utils/fire_service/questionairService.dart';
import 'package:flutter/material.dart';

import '../../DTO/questionaireDTO.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import 'minorWidgets/answerList.dart';
import 'minorWidgets/dropDown.dart';
import 'minorWidgets/questionList.dart';

class QuizCreation extends StatefulWidget {
  final String? editUId;

  const QuizCreation({Key? key, this.editUId}) : super(key: key);

  @override
  State<QuizCreation> createState() => _QuizCreationState();
}

class _QuizCreationState extends State<QuizCreation> {
  AuthService authService = AuthService.instance();
  Questionnaire questionnaire = Questionnaire(
      quizQuestion: [], uId: "", weeklyQuiz: false, dailyQuiz: false);
  List<Map<String, bool>> _answers = [];
  bool _dropdownValue = false;
  int questionEditIndex = -1;

  final TextEditingController _QuestionController = TextEditingController();
  final TextEditingController _AnswerController = TextEditingController();
  final TextEditingController _QuestionnaireController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editUId != null) {
      fetchQuestainnaireEdit();
      questionEditIndex = 0;
      print(widget.editUId);
    }
  }

  Future<void> fetchQuestainnaireEdit() async {
    this.questionnaire =
        await QuestionnaireService().getQuestionnaire(widget.editUId!);
    _answers = this.questionnaire.quizQuestion[0].answers;
  }

  void dropdownCallback(bool? selectedValue) {
    if (selectedValue is bool) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  void editQuestionCall(int newIndex, context, TextEditingController controller) {
    // Checks and dialog pop up to prevent missclicks
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                        controller.text = questionnaire.quizQuestion[newIndex].question;
                        _answers = questionnaire.quizQuestion[newIndex].answers;
                        questionEditIndex = newIndex;
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        controller.text = questionnaire.quizQuestion[newIndex].question;
                        _answers = questionnaire.quizQuestion[newIndex].answers;
                        _QuestionController.clear();
                        _AnswerController.clear();
                        questionEditIndex = newIndex;
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

  finishQuestionnaire(context) {
    if (questionnaire.quizQuestion.length >= 1) {
      showDialog(
          context: context,
          builder: (context) {
            String tempname = "";
            return AlertDialog(
              title: Text("Add a name to your questionnaire"),
              content: QuizTextFields(
                  _QuestionnaireController, "name here...", "Add your name"),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (_QuestionnaireController.text.isNotEmpty) {
                        tempname = _QuestionnaireController.text;
                        questionnaire.name = tempname;
                        if (widget.editUId == null) {
                          await QuestionnaireService()
                              .addQuestionaire(questionnaire);
                        }
                        else{
                          await QuestionnaireService().setQuestionaire(questionnaire, widget.editUId!);
                        }
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Give it a name please"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("ok"))
                                ],
                              );
                            });
                      }
                    },
                    child: Text("Finish")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("The quiz must have atleast one question"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Go back"))
              ],
            );
          });
    }
  }

  void questionCreation(BuildContext context) {
    // The method for creating questions based on the answer list
    num correctAnswers = 0;
    for (Map<String, bool> answer in _answers) {
      if (answer.values.first == true) {
        correctAnswers++;
      }
    }
    if (correctAnswers >= 1) {
      final quizAnswers = _answers.map((answer) {
        final answerText = answer.keys.first;
        final answerValue = answer.values.first == true;
        return <String, bool>{answerText: answerValue};
      }).toList();
      final quizQuestion = QuizQuestion(
        question: _QuestionController.text,
        answers: quizAnswers,
      );
      setState(() {
        if(questionEditIndex >= 0){
          questionnaire.quizQuestion.removeAt(questionEditIndex);
          questionEditIndex = -1;
        }
        questionnaire.quizQuestion.add(quizQuestion);
      });
      _QuestionController.clear();
      _AnswerController.clear();
      _answers.clear();
    } else {
      setState(() {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text("You need atleast one correct answer"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("cancel"))
                ],
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // main body of the quiz creator
    return Scaffold(
        appBar: AppBar(
          // back button
          title: Text(
            widget.editUId != null ? 'Questionnaire list' : 'Home',
          ),
          backgroundColor: hexStringToColor("fdbb2d"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            // styling
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
                // auth service
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
                    return Column(
                        // main body
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Expanded(
                            // Textfields and buttons
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: QuizTextFields(
                                              _QuestionController,
                                              "question name...",
                                              "Name your question")),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              questionCreation(context);
                                            });
                                          },
                                          icon: Icon(Icons.add))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          // Answer field
                                          child: QuizTextFields(
                                              _AnswerController,
                                              "write answer here...",
                                              "Add an answer")),
                                      Container(
                                        // Right or wrong asnwer selector
                                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: DropDownButtonCustom(
                                          initialValue: _dropdownValue,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _dropdownValue = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          // add answer to list button
                                          onPressed: () {
                                            setState(() {
                                              _answers.add({
                                                _AnswerController.text:
                                                    _dropdownValue
                                              });
                                            });
                                            _AnswerController.clear();
                                          },
                                          icon: Icon(Icons.add)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  // finish questionnaire button
                                  onPressed: () async {
                                    finishQuestionnaire(context);
                                  },
                                  style: QuizButtonStyle,
                                  child: Text(
                                    "Finish the questionaire",
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: questionEditIndex >= 0 ? const Text(
                                    "editing question",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                    ),
                                  )
                                : null,
                          ),
                          Container(
                            // List for both the answers and questions
                            height: 400,
                            child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    TabBar(tabs: [
                                      Tab(
                                          child: Text(
                                        "Answer list",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )),
                                      Tab(
                                          child: Text(
                                        "Question list",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ))
                                    ]),
                                    Expanded(
                                      child: TabBarView(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: AnswerList(answers: _answers),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: QuestionList(
                                              questions:
                                                  questionnaire.quizQuestion,
                                              onChanged: (int newIndex) {
                                                setState(() {
                                                  if (_QuestionController
                                                          .text.isNotEmpty &&
                                                      _answers.isNotEmpty) {
                                                    editQuestionCall(
                                                        newIndex, context, _QuestionController);
                                                  } else {
                                                    _QuestionController.text = questionnaire.quizQuestion[newIndex].question;
                                                    _answers = questionnaire
                                                        .quizQuestion[newIndex]
                                                        .answers;
                                                    questionEditIndex = newIndex;
                                                  }
                                                });
                                              }),
                                        ),
                                      ]),
                                    ),
                                  ],
                                )),
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
