import 'package:elosystem/screens/quizScreens/questionnaireProvideClasses/studentQuestionnaireProviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DTO/questionaireDTO.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/fire_service/questionairService.dart';

class QuestionnaireViewScreen extends StatefulWidget {
  final Questionnaire questionnaire;
  final String? type;

  QuestionnaireViewScreen({required this.questionnaire, this.type});

  @override
  _QuestionnaireViewScreenState createState() => _QuestionnaireViewScreenState();
}

class _QuestionnaireViewScreenState extends State<QuestionnaireViewScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late QuestionnaireViewProvider _provider;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _provider = QuestionnaireViewProvider(widget.questionnaire, widget.type, this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<QuestionnaireViewProvider>(
        builder: (context, provider, _) {
          QuizQuestion currentQuestion = provider.currentQuestion;
          int? selectedAnswerIndex = provider.selectedAnswerIndex;
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
                      groupValue: selectedAnswerIndex,
                      onChanged: (value) {
                        provider.onAnswerSelected(value as int, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

