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
      quizQuestion: [], name: "", uId: "", weeklyQuiz: false, dailyQuiz: false);
  List<Map<String, bool>> _answers = [];
  bool _dropdownValue = false;
  bool editMode = false;

  final TextEditingController _QuestionController = TextEditingController();
  final TextEditingController _AnswerController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editUId != null) {
      fetchQuestainnaireEdit();
    }
  }

  Future<void> fetchQuestainnaireEdit() async {
    this.questionnaire =
        await QuestionnaireService().getQuestionaire(widget.editUId!);
    _answers = this.questionnaire.quizQuestion[0].answers;
  }

  void dropdownCallback(bool? selectedValue) {
    if (selectedValue is bool) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  editQuestionCall(int newIndex, context) {
    // Checks and dialog pop up to prevent missclicks
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
                        _answers = questionnaire.quizQuestion[newIndex].answers;
                        editMode = true;
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _answers = questionnaire.quizQuestion[newIndex].answers;
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
                      child: Text("ok"))
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
          title: Text(
            widget.editUId != null ? 'Questionnaire list' : 'Home',
          ),
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
                                        child: TextField(
                                          controller: _QuestionController,
                                          style: TextStyle(
                                            color: Colors.black.withAlpha(200),
                                          ),
                                          enabled: true,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.help_outline,
                                              color: Colors.black,
                                            ),
                                            labelText:
                                                "What question do you want to ask",
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            hintText: "Question...",
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            fillColor:
                                                Colors.white.withAlpha(50),
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
                                        child: TextField(
                                          controller: _AnswerController,
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          enabled: true,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.error_outline,
                                              color: Colors.black,
                                            ),
                                            labelText: "Add an answer",
                                            hintText: "Answer...",
                                            hintStyle: const TextStyle(
                                                fontWeight: FontWeight.normal),
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            fillColor:
                                                Colors.white.withAlpha(50),
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
                                      Container(
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
                                  onPressed: () async {
                                    await QuestionnaireService()
                                        .addQuestionaire(questionnaire);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey; // Disabled color
                                        }
                                        return Colors.orange; // Default color
                                      },
                                    ),
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 24),
                                    ),
                                  ),
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
                            child: editMode
                                ? const Text(
                                    'In edit mode',
                                    style: TextStyle(
                                      color: Colors.red,
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
                                                        newIndex, context);
                                                  } else {
                                                    _answers = questionnaire
                                                        .quizQuestion[newIndex]
                                                        .answers;
                                                    editMode = true;
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
