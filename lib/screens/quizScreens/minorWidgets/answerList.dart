
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../questionnaireProvideClasses/teacherQuestionnaireProviders.dart';


class AnswerList extends StatefulWidget {
  final QuestionCreationState state;

  AnswerList({Key? key, required this.state}) : super(key: key);

  @override
  _AnswerListState createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {

  @override
  Widget build(BuildContext context) {
        return Expanded(
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.state.answers.isNotEmpty ? widget.state.answers.length : 1,
            itemBuilder: (BuildContext context, int index) {
              if (widget.state.answers.isEmpty) {
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
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    tileColor: Colors.green,
                    title: Text(widget.state.answers[index].keys.first),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: [
                          if (widget.state.answers[index].values.first == true)
                            Container(child: Icon(Icons.check_sharp))
                          else
                            Container(child: Icon(Icons.close)),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              widget.state.answers.removeAt(index);
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.state.changeAnswerDialog(context, index);
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
