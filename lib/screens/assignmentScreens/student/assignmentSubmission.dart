// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/fire_service/assignment_service.dart';
import '../../../utils/fire_service/auth_service.dart';

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
  final AssignmentService _assignmentService = AssignmentService.instance();
  final AuthService _authService = AuthService.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment['name']),
        backgroundColor: hexStringToColor("fdbb2d"),
      ),
      body: Padding(
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
                submitAssignment();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void submitAssignment() async {
    String gitRepoLink = _gitRepoLinkController.text;
    String assignmentId = widget.assignmentId;
    String studentId = await _authService.getCurrentUserId() ?? '';

// checking if both assignmentId and studentId are not empty
    if (assignmentId.isNotEmpty && studentId.isNotEmpty) {
      try {
        // aubmit the assignment using the assignmentService
        await _assignmentService.submitAssignment(assignmentId, studentId, gitRepoLink);

        // show a dialog to indicate successful submission
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submission Successful'),
            content: const Text('Your assignment has been submitted.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog and navigate back twice to return to the previous screen
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submission Failed'),
            content: const Text('There was an error while submitting your assignment. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Submission'),
          content: const Text('Please make sure to select an assignment'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
