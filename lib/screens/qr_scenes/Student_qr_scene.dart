import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/assignment_service.dart';

class StudentDataScreen extends StatelessWidget {
  final String studentId;

  StudentDataScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _pointsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data'),
        backgroundColor: hexStringToColor("fdbb2d"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(studentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Container(
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
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(data['userName']),
                  ),
                  ListTile(
                    title: const Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(data['score'].toString()),
                  ),
                  TextField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Points',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      int points = int.tryParse(_pointsController.text) ?? 0;
                      await AssignmentService.instance().assignPointsToStudent(studentId, points);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(hexStringToColor("fdbb2d")),
                    ),
                    child: const Text('Add Points', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
