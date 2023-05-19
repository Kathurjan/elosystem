import 'package:elosystem/DTO/questionaireDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionDialog extends StatefulWidget {
  final QuizQuestion quizQuestion;

  const QuestionDialog({Key? key, required this.quizQuestion}) : super(key: key);


  @override
  State<QuestionDialog> createState() => _QuestionDialog();
}

class _QuestionDialog extends State<QuestionDialog> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.quizQuestion.answers.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.quizQuestion.answers[index].keys.first),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.quizQuestion.answers.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}