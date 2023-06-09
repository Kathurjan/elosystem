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
        'studentId': studentId,
        'githubLink': githubLink,
        'pointsAssigned': false,
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
        // Get assignment data from Firestore
        Map<String, dynamic> assignmentData = doc.data() as Map<String, dynamic>;
        dynamic submissionDeadline = assignmentData['submissionDeadline'];

        if (submissionDeadline != null) {
          DateTime submissionDeadlineDate = submissionDeadline.toDate();
          int daysLeft = submissionDeadlineDate.difference(currentDate).inDays;

          if (daysLeft > 0) {  // Update condition here
            // Add assignment data to the assignmentData map
            assignmentData['id'] = doc.id;
            assignmentData['daysLeft'] = daysLeft;

            // Add the assignmentData to the assignments list
            assignments.add(assignmentData);
          }
        }
      }

      return assignments;
    } catch (e) {
      rethrow;
    }
  }

// getting the submissions for the specific assignments
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

  // getting all the assigments, if they have submisisons
  Future<List<Map<String, dynamic>>> getAllAssignmentsWithSubmissions() async {
    try {
      DateTime currentDate = DateTime.now();
      QuerySnapshot snapshot = await _assignmentsCollection.get();
      List<Map<String, dynamic>> assignments = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Get assignment data from firestore
        Map<String, dynamic> assignmentData = doc.data() as Map<String, dynamic>;
        dynamic submissionDeadline = assignmentData['submissionDeadline'];

        if (submissionDeadline != null) {
          DateTime submissionDeadlineDate = submissionDeadline.toDate();
          int daysLeft = submissionDeadlineDate.difference(currentDate).inDays;

          if (daysLeft >= 0) {
            // Add assignment data to the assignmentData map
            assignmentData['id'] = doc.id;
            assignmentData['daysLeft'] = daysLeft;

            // Get submissions for the current assignment
            List<Map<String, dynamic>> submissions =
            await getSubmissionsForAssignment(doc.id);
            assignmentData['submissions'] = submissions;

            // Add the assignmentData to the assignments list
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

  // getting the students id by the submissions
  Future<String?> getStudentIdBySubmission(String assignmentId, String githubLink) async {
    try {
      QuerySnapshot snapshot = await _assignmentsCollection
          .doc(assignmentId)
          .collection('submissions')
          .where('githubLink', isEqualTo: githubLink)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String studentId = snapshot.docs.first.id;
        return studentId;
      } else {
        return null;
      }
    } catch (error) {
      print('Error retrieving student ID by submission: $error');
      throw error;
    }
  }

  // method to give points to a student
  Future<void> assignPointsToStudent(String studentId, int points) async {
    try {
      DocumentReference studentRef = _usersCollection.doc(studentId);
      DocumentSnapshot studentSnapshot = await studentRef.get();

      if (studentSnapshot.exists) {
        int currentScore = studentSnapshot.get('score') as int;
        int updatedScore = currentScore + points;

        await studentRef.update({'score': updatedScore});
      } else {
      }
    } catch (error) {
      print('Error assigning points to student: $error');
      throw error;
    }
  }
  // method for updating the status of points assigned.
  Future<void> updatePointsAssignedStatus(String assignmentId, String studentId, bool status) async {
    try {
      await _assignmentsCollection
          .doc(assignmentId)
          .collection('submissions')
          .doc(studentId)
          .update({
        'pointsAssigned': status,
      });
    } catch (error) {
      print('Error updating points assigned status: $error');
      throw error;
    }
  }

}
