import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
/*
class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State {

  TextEditingController _questionController = TextEditingController();

  final question = {
    "TemplateQuestion": String,
    "Answers": [],
  };

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
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      resuableTextField("Question", Icons.question_mark_sharp, false, )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/