import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/fire_service/assignment_service.dart';

class TeacherAssignmentProvider with ChangeNotifier {
  final AssignmentService _assignmentService = AssignmentService.instance();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  Future<void> createAssign(BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;
    int numberOfDays = int.tryParse(daysController.text) ?? 0;

    if (name.isNotEmpty && description.isNotEmpty && numberOfDays > 0) {
      try {
        await _assignmentService.createAssignment(name, description, numberOfDays);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment created successfully')),
        );
        // clearing the text fields after creation.
        nameController.clear();
        descriptionController.clear();
        daysController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create assignment')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
    }
  }
}

class ExistingAssignmentProvider with ChangeNotifier {
  final AssignmentService _assignmentService = AssignmentService.instance();

  List<Map<String, dynamic>> assignments = [];
  Map<String, List<Map<String, dynamic>>> submissionsMap = {};

  Future<void> loadAssignments() async {
    assignments = await _assignmentService.getAllAssignmentsWithSubmissions();
    for (final assignment in assignments) {
      final assignmentId = assignment['id'];
      await loadSubmissions(assignmentId);
    }
    notifyListeners();
  }

  Future<void> loadSubmissions(String assignmentId) async {
    try {
      final submissions =
      await _assignmentService.getSubmissionsForAssignment(assignmentId);
      submissionsMap[assignmentId] = submissions;
      notifyListeners();
    } catch (error) {
      print('Error loading submissions for assignment: $error');
      submissionsMap[assignmentId] = [];
      notifyListeners();
    }
  }

  Future<void> assignPoints(
      String assignmentId, String studentId, int points) async {
    try {
      await _assignmentService.assignPointsToStudent(studentId, points);

      submissionsMap[assignmentId]?.forEach((submission) {
        if (submission['studentId'] == studentId) {
          submission['pointsAssigned'] = true;
        }
      });

      notifyListeners();
    } catch (error) {
      print('Error assigning points: $error');
    }
  }

  ExistingAssignmentProvider(){
    loadAssignments();
  }
}