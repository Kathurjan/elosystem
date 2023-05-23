import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/color_utils.dart';
import 'assignmentProviders/assignmentSubmissionProvider.dart';

class AssignmentSubmission extends StatefulWidget {
  final Map<String, dynamic> assignment;
  final String assignmentId;

  const AssignmentSubmission({
    Key? key,
    required this.assignment,
    required this.assignmentId,
  }) : super(key: key);

  @override
  _AssignmentSubmissionState createState() => _AssignmentSubmissionState();
}

class _AssignmentSubmissionState extends State<AssignmentSubmission> {
  final TextEditingController _gitRepoLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentSubmissionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.assignment['name']),
            backgroundColor: hexStringToColor("fdbb2d"),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assignment: ${widget.assignment['name']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter Git Repository Link:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _gitRepoLinkController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.submitAssignment(widget.assignmentId,
                        _gitRepoLinkController.text, context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: hexStringToColor("fdbb2d"),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
