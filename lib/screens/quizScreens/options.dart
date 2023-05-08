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
    // I want it to display a question in the format Question widget, then display the list of answers to said question in Answer widget


    return Column(
      children: [
        Question(
          questionaire.questions[questionIndex].questionText,
        ), //Question
          questionList(questionaire.questions[questionIndex])
      ],
    ); //Column
  }

  Widget questionList(QuestionDTO question){
    List<Widget> _widgetList = <Widget>[];
    for(var i = 0; i < question.answers.length; i++){
      _widgetList.add(Answer(answerQuestion, question.answers[i].txt, question.answers[i].Score));
    }
    return Column(children: _widgetList);
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
