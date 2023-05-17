import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentService {
  final CollectionReference<Map<String, dynamic>> _assignmentsCollection =
  FirebaseFirestore.instance.collection('assignments');
  final CollectionReference<Map<String, dynamic>> _usersCollection =
  FirebaseFirestore.instance.collection('users');
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

  // for studets to sumbit an assigment
  Future<void> submitAssignment(String assignmentId, String studentId, String githubLink) async {
    try {
      await _assignmentsCollection
          .doc(assignmentId)
          .collection('submissions')
          .doc(studentId)
          .set({
        'githubLink': githubLink,
      });
      print('Assignment submitted successfully.');
    } catch (error) {
      print('Error submitting assignment: $error');
      throw error;
    }
  }

  // get all assignments for the students.
  Future<List<Map<String, dynamic>>> getAvailableAssignments() async {
    try {
      DateTime currentDate = DateTime.now();

      QuerySnapshot snapshot = await _assignmentsCollection.get();
      List<Map<String, dynamic>> assignments = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> assignmentData = doc.data() as Map<String, dynamic>;
        dynamic submissionDeadline = assignmentData['submissionDeadline'];

        if (submissionDeadline != null) {
          DateTime submissionDeadlineDate = submissionDeadline.toDate();
          int daysLeft = submissionDeadlineDate.difference(currentDate).inDays;

          if (daysLeft >= 0) {
            assignmentData['id'] = doc.id;
            assignmentData['daysLeft'] = daysLeft;
            assignments.add(assignmentData);
          }
        }
      }

      return assignments;
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> getSubmissionsForAssignment(String assignmentId) async {
    try {
      QuerySnapshot snapshot = await _assignmentsCollection
          .doc(assignmentId)
          .collection('submissions')
          .get();

      List<Map<String, dynamic>> submissions = [];
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        String studentId = doc.id;
        Map<String, dynamic> submissionData = doc.data() as Map<String, dynamic>;

        // Fetch the student's name from the user database or student model
        DocumentSnapshot studentSnapshot = await _usersCollection.doc(studentId).get();
        print('Student snapshot data: ${studentSnapshot.data()}');

        if (studentSnapshot.exists) {
          String studentName = studentSnapshot.get('userName') as String;
          print('Student name: $studentName');

          // Include the student's name in the submission data
          submissionData['studentName'] = studentName;

          submissions.add(submissionData);
        } else {
          print('Student snapshot does not exist');
        }
      }

      return submissions;
    } catch (error) {
      print('Error retrieving submissions for assignment: $error');
      throw error;
    }
  }




  Future<List<Map<String, dynamic>>> getAllAssignmentsWithSubmissions() async {
    try {
      DateTime currentDate = DateTime.now();
      QuerySnapshot snapshot = await _assignmentsCollection.get();
      List<Map<String, dynamic>> assignments = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> assignmentData = doc.data() as Map<String, dynamic>;
        dynamic submissionDeadline = assignmentData['submissionDeadline'];

        if (submissionDeadline != null) {
          DateTime submissionDeadlineDate = submissionDeadline.toDate();
          int daysLeft = submissionDeadlineDate.difference(currentDate).inDays;

          if (daysLeft >= 0) {
            assignmentData['id'] = doc.id;
            assignmentData['daysLeft'] = daysLeft;
            List<Map<String, dynamic>> submissions =
            await getSubmissionsForAssignment(doc.id);
            assignmentData['submissions'] = submissions;
            assignments.add(assignmentData);
          }
        }
      }
      print('Assignments with submissions: $assignments');
      return assignments;
    } catch (e) {
      rethrow;
    }
  }

}
