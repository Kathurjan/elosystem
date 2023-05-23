import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/fire_service/assignment_service.dart';
import 'assignmentProviders/assignmentSubmissionProvider.dart';
import 'assignmentSubmission.dart';

class ListOfAssignmentStudent extends StatefulWidget {
  const ListOfAssignmentStudent({Key? key}) : super(key: key);

  @override
  State<ListOfAssignmentStudent> createState() =>
      _ListOfAssignmentStudentState();
}

class _ListOfAssignmentStudentState extends State<ListOfAssignmentStudent> {
  @override
  void initState() {
    super.initState();
    Provider.of<ListOfAssignmentProvider>(context, listen: false)
        .loadAvailableAssignments();
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
        child: Consumer<ListOfAssignmentProvider>(
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
                            builder: (context) => ChangeNotifierProvider(
                                create: (_) => AssignmentSubmissionProvider(),
                                child: AssignmentSubmission(
                                  assignmentId: assignmentId,
                                  assignment: assignment,
                                )),
                          ),
                        );
                      },
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
