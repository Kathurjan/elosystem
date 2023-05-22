import 'package:cloud_firestore/cloud_firestore.dart';

import '../../DTO/questionaireDTO.dart';

class QuestionnaireService {
  final CollectionReference questionnaireCollection =
      FirebaseFirestore.instance.collection("Questionaire");

  Future<void> addQuestionaire(Questionnaire questionnaire) async {
    Map<String, dynamic> questionnaireData = {
      "name": questionnaire.name,
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

  Future<Questionnaire> getQuestionnaire(String uId) async {
    try {
      final documentSnapshot = await questionnaireCollection.doc(uId).get();
      if (documentSnapshot.exists) {
        // Map Firestore document data to Questionnaire object
        Questionnaire questionnaire = Questionnaire(
          name: documentSnapshot["name"],
          dailyQuiz: documentSnapshot["dailyQuiz"],
          weeklyQuiz: documentSnapshot["weeklyQuiz"],
          uId: uId,
          quizQuestion: (documentSnapshot['quizQuestion'] as List<dynamic>)
              .map((questionData) {
            final question = questionData['question'] as String;

            final answersList = questionData['answers'] as List<dynamic>;
            final answers = <Map<String, bool>>[];

            for (final answerData in answersList) {
              final castedAnswerMap = <String, bool>{};
              castedAnswerMap[answerData.keys.first] =
                  answerData.values.first as bool;
              answers.add(castedAnswerMap);
            }
            return QuizQuestion(
              question: question,
              answers: answers,
            );
          }).toList(),
        );

        // Use the questionnaire object here
        return questionnaire;
      } else {
        print("doc snapshot does not exist");
        throw Error();
      }
    } catch (error) {
      print("Error retrieving questionnaire: $error");
      throw Error();
    }
  }

  Future<void> updateWeeklyOrDailyQuiz(String uId, String weekOrDay) async {
    if (weekOrDay != "weeklyQuiz" && weekOrDay != "dailyQuiz") {
      throw ArgumentError("Invalid value for weekOrDay: $weekOrDay");
    }

    final querySnapshot = await questionnaireCollection.get();
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null &&
          data.containsKey(weekOrDay) &&
          data[weekOrDay] == true &&
          doc.id != uId) {
        await questionnaireCollection.doc(doc.id).update({weekOrDay: false});
      }
    }

    await questionnaireCollection.doc(uId).update({weekOrDay: true});
  }

  Future<List<Map<String, String>>> getQuestionaireList() async {
    List<Map<String, String>> questionaries = [];
    await questionnaireCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String uId = doc["uId"];
        String name = doc["name"];
        questionaries.add({uId: name});
      }
    });
    return questionaries;
  }

  Future<Map<String, String>> getWeeklyOrDaily(String weekOrDay) async {
    try {
      if (weekOrDay != "weeklyQuiz" && weekOrDay != "dailyQuiz") {
        throw ArgumentError("Wrong value for: $weekOrDay");
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
      });
      return stringMap;
    } catch (error) {
      throw ArgumentError("Get an error: $error");
    }
  }

  Future<void> removeQuestionnaire(String uId) async {
    await questionnaireCollection.doc(uId).delete();
  }

  Future<void> setQuestionaire(Questionnaire questionnaire, String uID) async {
    Map<String, dynamic> questionnaireData = {
      "uId": uID,
      "name": questionnaire.name,
      "weeklyQuiz": questionnaire.weeklyQuiz,
      "dailyQuiz": questionnaire.dailyQuiz,
      'quizQuestion': questionnaire.quizQuestion.map((question) {
        return {
          'question': question.question,
          'answers': question.answers,
        };
      }).toList(),
    };

    print(uID);
    questionnaireCollection
        .doc(uID)
        .set(questionnaireData)
        .then((documentRef) {})
        .catchError((error) {
      print('Error adding questionnaire: $error');
    });
  }

  Future<void> addScoreFromQuiz(String uId, num score, String type, String QuestionnaireID) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uId).get();
      final docData = userDoc.data();
      if (!userDoc.exists) {
        throw ArgumentError("User doesnt exist?");
      }
      final quizTimeout = docData?["${type}QuizTimeout"] as Timestamp? ?? Timestamp.now();
      final quizTimeoutId = docData?["${type}QuizTimeoutID"] as String? ?? "";
      if (Timestamp.now().seconds > quizTimeout.seconds || quizTimeoutId == QuestionnaireID) {
        throw ArgumentError("You already completed this quiz or your timer is still running");
      }
      await FirebaseFirestore.instance.collection("users").doc(uId).update({
        "${type}QuizTimeout": Timestamp.now().seconds,
        "${type}QuizTimeoutID": QuestionnaireID,
        "score": FieldValue.increment(score),
      });
    } catch (error) {
      print("Error: $error");

      throw ArgumentError("Something went wrong");
    }
  }
}
