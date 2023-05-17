import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../reusable_widgets/resuable_widgets.dart';
import '../../../utils/color_utils.dart';
import 'existingAssignment.dart';
import '../../../utils/fire_service/assignment_service.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final AssignmentService _assignmentService = AssignmentService.instance();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // this part also handles the return of the scene, which is a build in back button essentially
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
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    resuableTextFieldNoPassWord(
                      "Name of Assignment",
                      Icons.assignment,
                      nameController,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 120,
                      child: resuableTextFieldNoPassWord(
                        "Description",
                        Icons.description,
                        descriptionController,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: resuableTextFieldNoPassWord(
                        "Number of Days",
                        Icons.calendar_today,
                        daysController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String name = nameController.text;
                        String description = descriptionController.text;
                        int numberOfDays = int.tryParse(daysController.text) ?? 0;

                        if (name.isNotEmpty && description.isNotEmpty && numberOfDays > 0) {
                          try {
                            await _assignmentService.createAssignment(name, description, numberOfDays);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Assignment created successfully')),
                            );
                            // clearing the text fields after creation.
                            nameController.clear();
                            descriptionController.clear();
                            daysController.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to create assignment')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all the fields')),
                          );
                        }
                      },
                      child: const Text('Create Assignment'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExistingAssignment(),
                          ),
                        );
                      },
                      child: const Text('View Previous Assignments'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
