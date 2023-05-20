import 'package:cloud_firestore/cloud_firestore.dart';

import '../../DTO/questionaireDTO.dart';

class QuestionnaireService {
  final CollectionReference questionnaireCollection =
      FirebaseFirestore.instance.collection("Questionaire");

  Future<void> addQuestionaire(Questionnaire questionnaire) async {
    Map<String, dynamic> questionnaireData = {
      "name": questionnaire.name,
      "uid": questionnaire.uId,
      "weeklyQuiz": questionnaire.weeklyQuiz,
      "dailyQuiz": questionnaire.dailyQuiz,
      'quizQuestion': questionnaire.quizQuestion.map((question) {
        return {
          'question': question.question,
          'answers': question.answers,
        };
      }).toList(),
    };

    questionnaireCollection.add(questionnaireData).then((documentRef) {
      print('Questionnaire added with ID: ${documentRef.id}');
      questionnaireCollection
          .doc(documentRef.id)
          .update({"uId": documentRef.id});
    }).catchError((error) {
      print('Error adding questionnaire: $error');
    });
  }

  Future<Questionnaire> getQuestionaire(String uId) async {
    await questionnaireCollection.doc(uId).get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        // Map Firestore document data to Questionnaire object
        Questionnaire questionnaire = Questionnaire(
          name: documentSnapshot["name"],
          dailyQuiz: documentSnapshot["dailyQuiz"],
          weeklyQuiz: documentSnapshot["weeklyQuiz"],
          uId: uId,
          quizQuestion: (documentSnapshot['quizQuestion'] as List<dynamic>)
              .map((questionData) {
            return QuizQuestion(
              question: questionData['question'],
              answers: (questionData['answers'] as List<dynamic>)
                  .cast<Map<String, bool>>(),
            );
          }).toList(),
        );

        // Use the questionnaire object here
        return questionnaire;
      } else {
        throw Error();
      }
    }).catchError((error) {
      throw Error();
    });
    throw Error();
  }

  updateWeeklyOrDailyQuiz(String uId, String weekOrDay) async {
    if (weekOrDay != "week" && weekOrDay != "day") {
      throw Error();
    }
    await questionnaireCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc[weekOrDay] == true && doc.id != uId) {
          questionnaireCollection.doc(doc.id).update({weekOrDay: false});
        }
      }
      questionnaireCollection.doc(uId).update({weekOrDay: true});
      return true;
    });
  }

  Future<List<Map<String, String>>> getQuestionaireList() async {
    List<Map<String, String>> questionaries = [];
    await questionnaireCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String uId = doc["uId"];
        String name = doc["name"];
        questionaries.add({"uId": uId, "name": name});
      }
    });
    return questionaries;
  }

  Future<Map<String, String>> getWeeklyOrDaily(String weekOrDay) async {
    if (weekOrDay != "week" && weekOrDay != "day") {
      throw Error();
    }
    Map<String, String> stringMap = {};
    await questionnaireCollection
        .where(weekOrDay, isEqualTo: true)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs[0].exists) {
        String uId = querySnapshot.docs[0]["uId"];
        String name = querySnapshot.docs[0]["name"];
        stringMap = {uId: name};
      }
      return stringMap;
    });
    throw Error();
  }
}
