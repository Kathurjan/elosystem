import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../questionnaireProvideClasses/teacherQuestionnaireProviders.dart';

class QuestionList extends StatefulWidget {
  final QuestionCreationState state;

  QuestionList({Key? key, required this.state}) : super(key: key);

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
        // check item count to diplay default if false
        itemCount: widget.state.questionnaire.quizQuestion.isNotEmpty ? widget.state.questionnaire.quizQuestion.length : 1,
        itemBuilder: (BuildContext context, int index) {
          if (widget.state.questionnaire.quizQuestion.isEmpty) {
            return Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    'No answers added',
                    style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          } else {
            final questionTxt = widget.state.questionnaire.quizQuestion[index].question;
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
                          widget.state.removeQuestion(index);

                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.state.onQuestionChangeCall(index, context);
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
