import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerDialog extends StatefulWidget {
  final String initialKey;
  final Function(String) onSaved;

  const AnswerDialog({Key? key, required this.initialKey, required this.onSaved}) : super(key: key);

  @override
  _AnswerDialogState createState() => _AnswerDialogState();
}

class _AnswerDialogState extends State<AnswerDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Answer'),
      content: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter answer...',
            ),
          ),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSaved(_controller.text);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}