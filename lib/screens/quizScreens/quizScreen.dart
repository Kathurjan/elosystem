import 'package:elosystem/DTO/questionaireDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';
import 'options.dart';
import 'result.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen(BuildContext context, {Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State {

  var _questionIndex = 0;
  var _totalResult = 0;

  final _questionaire = fakeObject().questionaire;

  @override
  void initState() {
    setState(() {
      _questionIndex = 0;
      _totalResult = 0;
    });
    super.initState();
  }

  void _resetQuiz() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _questionIndex = 0;
        _totalResult = 0;
      });
    });
  }

  void _answerQuestion(int score) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _totalResult += score;
        _questionIndex = _questionIndex + 1;
      });
    });

  print(_questionIndex);

  if

  (

  _questionIndex < _questionaire.questions.length) {
  // ignore: avoid_print
  print('We have more questions!');
  } else {
  // ignore: avoid_print
  print('No more questions!');
  }
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
        padding: const EdgeInsets.all(30.0),
        child: _questionIndex < _questionaire.questions.length
            ? Quiz(
          answerQuestion: _answerQuestion,
          questionIndex: _questionIndex,
          questionaire: _questionaire,
        ) //Quiz
            : Result(_totalResult, _resetQuiz),
      ), //Padding
    ),
  );
}}
