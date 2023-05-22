import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/fire_service/assignment_service.dart';
import 'dart:core';

class ExistingAssignment extends StatefulWidget {
  const ExistingAssignment({Key? key}) : super(key: key);

  @override
  State<ExistingAssignment> createState() => _ExistingAssignmentState();
}

class _ExistingAssignmentState extends State<ExistingAssignment> {
  final AssignmentService _assignmentService = AssignmentService.instance();

  List<Map<String, dynamic>> assignments = [];
  Map<String, List<Map<String, dynamic>>> submissionsMap = {};

  TextEditingController pointsFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    assignments = await _assignmentService.getAllAssignmentsWithSubmissions();
    for (final assignment in assignments) {
      final assignmentId = assignment['id'];
      await loadSubmissions(assignmentId);
    }
    setState(() {});
  }

  Future<void> loadSubmissions(String assignmentId) async {
    try {
      final submissions =
      await _assignmentService.getSubmissionsForAssignment(assignmentId);
      setState(() {
        submissionsMap[assignmentId] = submissions;
      });
    } catch (error) {
      print('Error loading submissions for assignment: $error');
      setState(() {
        submissionsMap[assignmentId] = [];
      });
    }
  }

  Future<void> assignPoints(
      String assignmentId,
      String studentId,
      int points,
      ) async {
    try {
      await _assignmentService.assignPointsToStudent(studentId, points);

      setState(() {
        // change the points assinged to true based on studenId
        submissionsMap[assignmentId]?.forEach((submission) {
          if (submission['studentId'] == studentId) {
            submission['pointsAssigned'] = true;
          }
        });
      });

      pointsFieldController.clear();
    } catch (error) {
      print('Error assigning points: $error');
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
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
        child: ListView.builder(
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            // Fetch the assignment Map object at the index from the list of assignments
            final assignment = assignments[index];
            // Retrieve the 'id' from the fetched assignment
            final assignmentId = assignment['id'];
            final assignmentName = assignment['name'];
            final submissions = submissionsMap[assignmentId] ?? [];
            return Card(
              margin: const EdgeInsets.all(10.0),
              elevation: 2.0,
              child: ExpansionTile(
                title: Text(
                  assignmentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onExpansionChanged: (expanded) {
                  if (expanded && assignmentId != null) {
                    // Load submissions when the tile is expanded
                    loadSubmissions(assignmentId);
                  }
                },
                children: [
                  if (submissions.isEmpty)
                    const ListTile(
                      title: Text(
                        'No submissions found',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    ...submissions.map((submission) => ListTile(
                      title: Text(
                        submission['studentName'] ?? 'Unknown Student',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // Set the color based on whether points are assigned or not
                          color: submission['pointsAssigned'] == true ? Colors.green : Colors.red,
                        ),
                      ),
                      subtitle: TextButton(
                        onPressed: () {
                          FlutterClipboard.copy(submission['githubLink']).then((result) {
                            final snackBar = SnackBar(
                              content: Text('GitHub link copied to clipboard'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                        },
                        child: Text(
                          submission['githubLink'],
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: submission['pointsAssigned'] == true ? null : () async {
                          var githubLink = submission['githubLink'];
                          String? studentId = await _assignmentService.getStudentIdBySubmission(assignmentId, githubLink);
                          if (studentId != null) {
                            var points = int.tryParse(pointsFieldController.text);
                            if (points != null) {
                              // Assign points to the student
                              assignPoints(assignmentId, studentId, points);
                              pointsFieldController.clear();
                            } else {
                              print('Invalid input in points field');
                            }
                          } else {
                            print('Failed to get student ID');
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            hexStringToColor("fdbb2d"),
                          ),
                        ),
                        child: const Text(
                          'Assign Points',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),

                  TextField(
                    controller: pointsFieldController,
                    decoration: const InputDecoration(
                      labelText: 'How many points',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
