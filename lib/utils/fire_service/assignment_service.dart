import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentService {
  final CollectionReference _assignmentsCollection =
  FirebaseFirestore.instance.collection('assignments');
  //singleton stuff
  static final AssignmentService _instance = AssignmentService._();
  AssignmentService._();
  static AssignmentService instance() => _instance;

  Future<void> createAssignment(
      String name, String description, int numberOfDays) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime submissionDeadline = currentDate.add(Duration(days: numberOfDays));
      bool isSubmissionOver = false;

      if (currentDate.isAfter(submissionDeadline)) {
        isSubmissionOver = true;
      }

      await _assignmentsCollection.add({
        'name': name,
        'description': description,
        'numberOfDays': numberOfDays,
        'currentDate': currentDate,
        'submissionDeadline': submissionDeadline,
        'isSubmissionOver': isSubmissionOver,
      });
    } catch (e) {
      rethrow;
    }
  }


  // method used for getting all assignments
  Future<List<Map<String, dynamic>>> getAllAssignments() async {
    try {
      QuerySnapshot snapshot = await _assignmentsCollection.get();
      List<Map<String, dynamic>> assignments =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      return assignments;
    } catch (e) {
      rethrow;
    }
  }

  // to for studets to sumbit an assigment
  Future<void> submitAssignment(String assignmentId, String studentId, String githubLink) async {
    try {
      await _assignmentsCollection.doc(assignmentId).collection('submissions').doc(studentId).set({
        'githubLink': githubLink,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Method to get submissions for a specific assignment, for teaches to see the students assignment.
  Future<List<Map<String, dynamic>>> getSubmissionsForAssignment(String assignmentId) async {
    try {
      QuerySnapshot snapshot = await _assignmentsCollection
          .doc(assignmentId)
          .collection('submissions')
          .get();
      List<Map<String, dynamic>> submissions =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      return submissions;
    } catch (e) {
      rethrow;
    }
  }
}
