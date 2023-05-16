import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/assignment_service.dart';

class ExistingAssignment extends StatefulWidget {
  const ExistingAssignment({Key? key}) : super(key: key);

  @override
  State<ExistingAssignment> createState() => _ExistingAssignmentState();
}

class _ExistingAssignmentState extends State<ExistingAssignment> {
  final AssignmentService _assignmentService = AssignmentService.instance();

  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> submissions = [];

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    assignments = await _assignmentService.getAllAssignments();
    // set state is called to rebuild the widget so if something changes it will rebuild it too show case that
    setState(() {});
  }

  Future<void> loadSubmissions(String assignmentId) async {
    submissions = await _assignmentService.getSubmissionsForAssignment(assignmentId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: hexStringToColor("fdbb2d"), // Set the app bar color
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
                  if (expanded) {
                    loadSubmissions(assignmentId);
                  }
                },
                children: [
                  for (final submission in submissions)
                    ListTile(
                      title: Text(
                        submission['studentName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        submission['githubLink'],
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Assign points to the submission
                          // Call a method in the AssignmentService to assign points
                          // Pass the assignmentId, studentId, and points as parameters
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
