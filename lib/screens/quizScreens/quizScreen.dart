import 'package:flutter/material.dart';
import '../../DTO/questionaireDTO.dart';
import '../../utils/color_utils.dart';


class QuizScreen extends StatefulWidget {
  final Questionnaire questionnaire;

  QuizScreen({required this.questionnaire});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;



  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    super.initState();
  }

  void _onAnswerSelected(int selectedAnswerIndex) {
    if (widget.questionnaire.quizQuestion[_currentQuestionIndex]
        .answers[selectedAnswerIndex].values.first ==
        true) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < widget.questionnaire.quizQuestion.length - 1) {
      _animationController.forward().then((_) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswerIndex = null;
        });
        _animationController.reset();
      });
    } else {
      // Quiz is over, show score
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Quiz finished'),
          content: Text(
              'Your score is $_score out of ${widget.questionnaire.quizQuestion.length}, your extra score credit will only be added to your personal rating ONCE'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    QuizQuestion currentQuestion =
    widget.questionnaire.quizQuestion[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Selection'),
        backgroundColor: hexStringToColor("fdbb2d"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.of(context).pop();
          },
        ),
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
                groupValue: _selectedAnswerIndex,
                onChanged: (value) {
                  setState(() {
                    _selectedAnswerIndex = value as int?;
                    _onAnswerSelected(_selectedAnswerIndex!);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}