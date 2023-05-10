import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentDataScreen extends StatelessWidget {
  final String studentId;

  StudentDataScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    // Fetch student data from Firestore based on studentId
    return Scaffold(
      appBar: AppBar(title: Text('Student Data')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(studentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Text('Name: ${data['userName']}'),
                Text('Score: ${data['Score']}'),
                // Add more fields as needed
              ],
            );
          }
        },
      ),
    );
  }
}
