import 'package:clipboard/clipboard.dart';
import 'package:elosystem/screens/assignmentScreens/teacher/teachAssignmentProviders/teacherAssignmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/fire_service/assignment_service.dart';

class ExistingAssignment extends StatefulWidget {
  const ExistingAssignment({Key? key}) : super(key: key);

  @override
  State<ExistingAssignment> createState() => _ExistingAssignmentState();
}

class _ExistingAssignmentState extends State<ExistingAssignment> {
  final AssignmentService _assignmentService = AssignmentService.instance();

  TextEditingController pointsFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ExistingAssignmentProvider>(context, listen: false).loadAssignments();
  }

  @override
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
        child: Consumer<ExistingAssignmentProvider>(
          builder: (context, provider, _) {
            if (provider.assignments.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: provider.assignments.length,
                itemBuilder: (context, index) {
                  final assignment = provider.assignments[index];
                  final assignmentId = assignment['id'];
                  final assignmentName = assignment['name'];
                  final submissions = provider.submissionsMap[assignmentId] ?? [];

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
                          provider.loadSubmissions(assignmentId);
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
                                color: submission['pointsAssigned'] == true
                                    ? Colors.green
                                    : Colors.red,
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
                              onPressed: submission['pointsAssigned'] == true
                                  ? null
                                  : () async {
                                var githubLink = submission['githubLink'];
                                String? studentId = await _assignmentService.getStudentIdBySubmission(
                                    assignmentId, githubLink);
                                if (studentId != null) {
                                  var points = int.tryParse(pointsFieldController.text);
                                  if (points != null) {
                                    provider.assignPoints(assignmentId, studentId, points);
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
              );
            }
          },
        ),
      ),
    );
  }
}

