import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/color_utils.dart';
import '../../../../utils/fire_service/assignment_service.dart';
import '../../../../utils/fire_service/auth_service.dart';

class AssignmentSubmissionProvider with ChangeNotifier {
  final AssignmentService _assignmentService = AssignmentService.instance();
  final AuthService _authService = AuthService.instance();

  Future<void> submitAssignment(String assignmentId, String gitRepoLink, BuildContext context) async {
    String studentId = await _authService.getCurrentUserId() ?? '';

    // checking if both assignmentId and studentId are not empty
    if (assignmentId.isNotEmpty && studentId.isNotEmpty) {
      try {
        // submit the assignment using the assignmentService
        await _assignmentService.submitAssignment(
          assignmentId,
          studentId,
          gitRepoLink,
        );

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
            backgroundColor: hexStringToColor("fdbb2d"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submission Failed'),
            content: const Text(
              'There was an error while submitting your assignment. Please try again.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
            backgroundColor: hexStringToColor("fdbb2d"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          backgroundColor: hexStringToColor("fdbb2d"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}

class ListOfAssignmentProvider with ChangeNotifier {
  final AssignmentService _assignmentService = AssignmentService.instance();
  List<Map<String, dynamic>> assignments = [];

  Future<void> loadAvailableAssignments() async {
    assignments = await _assignmentService.getAvailableAssignments();
    notifyListeners();
  }
}