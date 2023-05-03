import 'package:elosystem/DTO/questionaireDTO.dart';
import 'package:flutter/material.dart';

import './answer.dart';

class Quiz extends StatelessWidget {
  final Questionaire questionaire;
  final int questionIndex;
  final Function answerQuestion;

  const Quiz({
    Key? key,
    required this.questionaire,
    required this.answerQuestion,
    required this.questionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questionaire.questions[questionIndex].questionText,
        ), //Question
        ...(questionaire.questions[questionIndex].answers as List<Map<String, Object>>)
            .forEach((element) {return Answer (answerQuestion(element.)) })
        )
      ],
    ); //Column
  }
}


class Question extends StatelessWidget {
  final String questionText;

  const Question(this.questionText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Text(
        questionText,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ), //Text
    ); //Contaier
  }
}
