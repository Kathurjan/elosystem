import 'dart:async';

import 'package:elosystem/screens/quizScreens/questionnaireCreationScreen.dart';
import 'package:flutter/material.dart';
import '../../../DTO/questionaireDTO.dart';
import '../../../reusable_widgets/resuable_widgets.dart';
import '../../../utils/fire_service/auth_service.dart';
import '../../../utils/fire_service/questionairService.dart';
import '../../../utils/slideAnimation.dart';

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

  void changeQuestion(int newIndex){
    // set's all the value's to the selected question
    questionController.text = questionnaire.quizQuestion[newIndex].question;
    answers = questionnaire.quizQuestion[newIndex].answers;
    questionEditIndex = newIndex;
  }

  void onQuestionChangeCall(int newIndex, context) {
    // If there are currently answer's in the list we open a dialog to info the user
    if (answers.isNotEmpty) {
      changeQuestionDialog(newIndex, context);
    } else {
      changeQuestion(newIndex);
      notifyListeners();
    }
  }

  void removeQuestion(int index) {
    questionnaire.quizQuestion.removeAt(index);
    notifyListeners();
  }

  void changeQuestionDialog(int newIndex, context) {
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
                      questionCreation(context); // Saves the current question

                      changeQuestion(newIndex);

                      Navigator.of(context).pop();
                      notifyListeners();
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {

                      changeQuestion(newIndex);

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

  void questionCreation(BuildContext context) {
    // The method for creating questions based on the answer list

    // Check for a correct answer within the list
    bool hasCorrectAnswer = answers.any((answer) => answer.values.first == true);


    if (hasCorrectAnswer == true) {
      final quizAnswers = answers.map((answer) {
        final answerText = answer.keys.first;
        final answerValue = answer.values.first == true;
        return <String, bool>{answerText: answerValue};
      }).toList();


      final quizQuestion = QuizQuestion(
        question: questionController.text,
        answers: quizAnswers,
      );

      // if we are editing a question we remove it and re add it to the list
      if (questionEditIndex >= 0) {
        questionnaire.quizQuestion.removeAt(questionEditIndex);
        questionEditIndex = -1;
      }

      questionnaire.quizQuestion.add(quizQuestion);
      questionController.clear();
      answers.clear();
      notifyListeners();
    }

    else {
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

  finishQuestionnaire(context, String? uId) {
    if (questionnaire.quizQuestion.length >= 1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Add a name to your questionnaire"),
              content: QuizTextFields(
                  questionController, "name here...", "Add your name"),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (questionController.text.isNotEmpty)
                      {
                        questionnaire.name = questionController.text;

                        if (uId == null) { //save the questionnaire as a new one if not in editmode
                          await QuestionnaireService()
                              .addQuestionaire(questionnaire);
                        }
                        else
                        { // change the old Questionnaire
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




  void addAnswer() {
    // simply add the answer to the list
    answers.add({answerController.text: dropdownValue});
    notifyListeners();
  }

  void changeAnswerDialog(BuildContext context, int index) {
    // open a dialog to allow for the answer to be edited (only text)
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

  QuestionCreationState(String? uId){
    if(uId != null){
      fetchQuestainnaireEdit(uId);
    }
  }
}

///////////
class QuestionnaireListState with ChangeNotifier {
  List<Map<String, String>> listOfQuestionnaires = [];
  StreamController<List<Map<String, String>>> _questionnairesController = StreamController<List<Map<String, String>>>();

  void removeQuestionnaire(String questionnaireId) {
    QuestionnaireService().removeQuestionnaire(questionnaireId);
    listOfQuestionnaires.removeWhere((map) => map.containsKey(questionnaireId));
    notifyListeners();
  }

  void goToQuestionaireCreation(String? uId, BuildContext context){
    Navigator.push(
      context,
      SlideAnimationRoute(
        child: QuestionnaireCreationScreen(editUId: uId),
        slideRight: true,
      ),
    );

  }

  QuestionnaireListState(){
    subscribeToQuestionnaires();
  }



  Stream<List<Map<String, String>>> get questionnairesStream => _questionnairesController.stream;

  Future<void> subscribeToQuestionnaires() async {
    Stream<List<Map<String, String>>> stream = QuestionnaireService().streamQuestionnaireList();
    stream.listen((questionnaires) {
      listOfQuestionnaires = questionnaires;
      _questionnairesController.add(questionnaires);
      notifyListeners();
    });
  }
}