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
      final submissions = await _assignmentService.getSubmissionsForAssignment(assignmentId);
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

  void assignPoints(String assignmentId, String studentId, int points) {
    // @todo  need to finish this part so the teacher can add points to the submission
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
            final assignment = assignments[index];
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: TextButton(
                        onPressed: () {
                          launch(Uri.parse(submission['githubLink']).toString()); // Convert the String URL to Uri
                        },
                        child: Text(
                          submission['githubLink'],
                          style: TextStyle(
                            color: Colors.blue, // Set the hyperlink text color
                          ),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          assignPoints(assignmentId!, submission['studentId'], 10);
                          Navigator.pop(context);
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

                ],
              ),
            );
          },
        ),
      ),
    );
  }


}
