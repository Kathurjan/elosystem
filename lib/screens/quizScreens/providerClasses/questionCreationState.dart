import 'package:flutter/material.dart';
import '../../../DTO/questionaireDTO.dart';
import '../../../reusable_widgets/resuable_widgets.dart';
import '../../../utils/fire_service/auth_service.dart';
import '../../../utils/fire_service/questionairService.dart';

class QuestionCreationState extends ChangeNotifier {
  AuthService authService = AuthService.instance();
  Questionnaire questionnaire = Questionnaire(quizQuestion: [], uId: "", weeklyQuiz: false, dailyQuiz: false);
  List<Map<String, bool>> answers = [];
  bool dropdownValue = false;
  int questionEditIndex = -1;

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController questionnaireController = TextEditingController();
  final TextEditingController tempController = TextEditingController();

  Future<void> fetchQuestainnaireEdit(String uId) async {
    questionnaire = await QuestionnaireService().getQuestionnaire(uId);
    answers = questionnaire.quizQuestion[0].answers;
  }

  void editQuestionCall(int newIndex, context) {
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
                      questionController.text =
                          questionnaire.quizQuestion[newIndex].question;
                      answers = questionnaire.quizQuestion[newIndex].answers;
                      questionEditIndex = newIndex;

                      Navigator.of(context).pop();
                      questionCreation(context);
                      notifyListeners();
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      questionController.text =
                          questionnaire.quizQuestion[newIndex].question;
                      answers = questionnaire.quizQuestion[newIndex].answers;
                      questionController.clear();
                      questionEditIndex = newIndex;

                      Navigator.of(context).pop();
                      notifyListeners();
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

  finishQuestionnaire(context, String? uId) {
    if (questionnaire.quizQuestion.length >= 1) {
      showDialog(
          context: context,
          builder: (context) {
            String tempname = "";
            return AlertDialog(
              title: Text("Add a name to your questionnaire"),
              content: QuizTextFields(
                  questionController, "name here...", "Add your name"),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (questionController.text.isNotEmpty) {
                        tempname = questionController.text;
                        questionnaire.name = tempname;
                        if (uId == null) {
                          await QuestionnaireService()
                              .addQuestionaire(questionnaire);
                        } else {
                          await QuestionnaireService()
                              .setQuestionaire(questionnaire, uId);
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
    for (Map<String, bool> answer in answers) {
      if (answer.values.first == true) {
        correctAnswers++;
      }
    }
    if (correctAnswers >= 1) {
      final quizAnswers = answers.map((answer) {
        final answerText = answer.keys.first;
        final answerValue = answer.values.first == true;
        return <String, bool>{answerText: answerValue};
      }).toList();
      final quizQuestion = QuizQuestion(
        question: questionController.text,
        answers: quizAnswers,
      );
      if (questionEditIndex >= 0) {
        questionnaire.quizQuestion.removeAt(questionEditIndex);
        questionEditIndex = -1;
      }
      questionnaire.quizQuestion.add(quizQuestion);
      questionController.clear();
      answers.clear();
      notifyListeners();
    } else {
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
    }
  }

  void onChangedCall(int newIndex, context) {
    if (questionController.text.isNotEmpty && answers.isNotEmpty) {
      editQuestionCall(newIndex, context);
    } else {
      questionController.text = questionnaire.quizQuestion[newIndex].question;
      answers = questionnaire.quizQuestion[newIndex].answers;
      questionEditIndex = newIndex;
      notifyListeners();
    }
  }

  void addAnswer() {
    answers.add({answerController.text: dropdownValue});
    notifyListeners();
  }

  void editAnswer(BuildContext context, int index) {
    tempController.text = answers[index].keys.first;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit the answer"),
          content: Container(
            height: 60,
            child: TextField(
              controller: tempController,
              decoration: InputDecoration(
                hintText: 'Enter answer...',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // removes the answer at the index and re-adds it
                bool value = answers[index][answers[index].keys.first]!;
                answers[index].remove(answers[index].keys.first);
                answers[index][tempController.text] = value;
                notifyListeners();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void changeDropDown(bool? newValue) {
    if (newValue != null) {
      dropdownValue = newValue;
      notifyListeners();
    }}

  void questionRemoved(int index) {
    questionnaire.quizQuestion.removeAt(index);
    notifyListeners();
  }


}
