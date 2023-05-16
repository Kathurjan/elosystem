import 'package:elosystem/screens/quizScreens/answerDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../DTO/questionaireDTO.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';

class QuizCreation extends StatefulWidget {
  const QuizCreation({Key? key}) : super(key: key);

  @override
  State<QuizCreation> createState() => _QuizCreationState();
}

class _QuizCreationState extends State<QuizCreation> {
  AuthService authService = AuthService.instance();
  Questionaire questionaire = new Questionaire(quizQuestion: []);
  List<String> _answers = [];

  final TextEditingController _QuestionController = TextEditingController();
  final TextEditingController _AnswerController = TextEditingController();

  void _showEditAnswerDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnswerDialog(
          initialValue: _answers[index],
          onSaved: (newValue) {
            setState(() {
              _answers[index] = newValue;
            });
          },
        );
      },
    );
  }

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
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
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
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                                TextField(
                                  controller: _AnswerController,
                                  style: TextStyle(
                                      color: Colors.white.withAlpha(200)),
                                  enabled: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.question_mark,
                                      color: Colors.white60,
                                    ),
                                    labelText: "Add an answer to the question",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withAlpha(200)),
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    fillColor: Colors.white.withAlpha(50),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _answers.add(_AnswerController.text);
                                    });
                                    _AnswerController.clear();
                                  },
                                  child: Text("Add to list",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final quizQuestion = QuizQuestion(
                                      question: _QuestionController.text,
                                      answers: _answers,
                                      correctAnswerIndex: 0,
                                    );
                                    setState(() {
                                      questionaire.quizQuestion
                                          .add(quizQuestion);
                                    });
                                    _QuestionController.clear();
                                    _AnswerController.clear();
                                  },
                                  child: Text("Finish the question",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                shrinkWrap: false,
                                itemCount: _answers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(_answers[index]),
                                    trailing: Container(
                                      width: 80,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                _answers.removeAt(index);
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showEditAnswerDialog(
                                                  context, index);
                                            },
                                            child: Icon(
                                              Icons.edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ]);
                  }
                },
              ),
            )));
  }
}
