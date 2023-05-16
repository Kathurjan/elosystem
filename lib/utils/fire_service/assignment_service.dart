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
        'isSubmissionOver': isSubmissionOver,
      });
    } catch (e) {
      rethrow;
    }
  }


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

}
