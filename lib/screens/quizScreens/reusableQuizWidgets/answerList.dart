import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'answerDialog.dart';

class AnswerList extends StatefulWidget {
  final List<Map<String, bool>> answers;

  AnswerList({Key? key, required this.answers}) : super(key: key);

  @override
  _AnswerListState createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  void _showEditAnswerDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnswerDialog(
          initialKey: widget.answers[index].keys.first,
          onSaved: (newValue) {
            setState(() {
              bool value =
                  widget.answers[index][widget.answers[index].keys.first]!;
              widget.answers[index].remove(widget.answers[index].keys.first);
              widget.answers[index][newValue] = value;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
        return Expanded(
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.answers.isNotEmpty ? widget.answers.length : 1,
            itemBuilder: (BuildContext context, int index) {
              if (widget.answers.isEmpty) {
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
                final answerText = widget.answers[index].keys.first ?? '';
                final trueFalseCheck = widget.answers[index].values.first;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    tileColor: Colors.green,
                    title: Text(answerText),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: [
                          if (trueFalseCheck == true)
                            Container(child: Icon(Icons.check_sharp))
                          else
                            Container(child: Icon(Icons.close)),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                widget.answers.removeAt(index);
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              _showEditAnswerDialog(context, index);
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
