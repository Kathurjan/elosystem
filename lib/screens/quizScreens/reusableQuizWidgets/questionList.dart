import 'package:elosystem/DTO/questionaireDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'answerDialog.dart';

class QuestionList extends StatefulWidget {
  final List<QuizQuestion> questions;
  final Function(int) onChanged;

  QuestionList({Key? key, required this.questions, required this.onChanged}) : super(key: key);

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: widget.questions.isNotEmpty ? widget.questions.length : 1,
        itemBuilder: (BuildContext context, int index) {
          if (widget.questions.isEmpty) {
            return Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    'No answers added',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          } else {
            final questionTxt = widget.questions[index].question;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                tileColor: Colors.green,
                title: Text(questionTxt),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.questions.removeAt(index);
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onChanged(index);
                        },
                        child: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );

  }
}
