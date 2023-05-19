import 'package:flutter/material.dart';
import '../../DTO/questionaireDTO.dart';


class QuizScreen extends StatefulWidget {
  final Questionaire questionaire;

  QuizScreen({required this.questionaire});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  void _onAnswerSelected(int selectedAnswerIndex) {
    if (widget.questionaire.quizQuestion[_currentQuestionIndex].answers[selectedAnswerIndex].values.first == true) {
      setState(() {
        _score++;
      });
    }


    if (_currentQuestionIndex < widget.questionaire.quizQuestion.length - 1) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => QuizScreen(questionaire: widget.questionaire),
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Quiz is over, show score
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Quiz finished'),
          content: Text('Your score is $_score out of ${widget.questionaire.quizQuestion.length}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    QuizQuestion currentQuestion = widget.questionaire.quizQuestion[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ...List.generate(
              currentQuestion.answers.length,
                  (index) => RadioListTile(
                title: Text(currentQuestion.answers[index].keys.first),
                value: index,
                groupValue: null,
                onChanged: (value) => {
                  if(value != null){
                    _onAnswerSelected(value)
                  }},
              ),
            ),
          ],
        ),
      ),
    );
  }
}