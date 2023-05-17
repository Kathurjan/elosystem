import 'package:flutter/material.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/fire_service/assignment_service.dart';
import 'assignmentSubmission.dart';

class ListOfAssignmentStudent extends StatefulWidget {
  const ListOfAssignmentStudent({Key? key}) : super(key: key);

  @override
  State<ListOfAssignmentStudent> createState() => _ListOfAssignmentStudentState();
}

class _ListOfAssignmentStudentState extends State<ListOfAssignmentStudent> {
  final AssignmentService _assignmentService = AssignmentService.instance();
  List<Map<String, dynamic>> assignments = [];

  @override
  void initState() {
    super.initState();
    loadAvailableAssignments();
  }

  Future<void> loadAvailableAssignments() async {
    assignments = await _assignmentService.getAvailableAssignments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Assignments'),
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
            final daysLeft = assignment['daysLeft'];

            return Card(
              margin: const EdgeInsets.all(10.0),
              elevation: 2.0,
              child: ListTile(
                title: Text(
                  assignmentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '$daysLeft days left',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentSubmission(
                        assignmentId: assignmentId,
                        assignment: assignment,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
