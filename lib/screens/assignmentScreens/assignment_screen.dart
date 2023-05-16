// ignore_for_file: use_build_context_synchronously

import 'package:elosystem/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/slideAnimation.dart';
import '../teacher_screen.dart';
import 'existingAssignment.dart';
import '../../utils/fire_service/assignment_service.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();


}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final AuthService _authService = AuthService.instance(); // instance of auth service
  final AssignmentService _assignmentService = AssignmentService.instance();// instance of assigmentservice
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
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
                top: MediaQuery.of(context).size.height * 0.05,
                left: 0,
                child: Column(
                  children: [
                    ReturnButton("Back", context, () async {
                      String userType = await _authService.getUserType();
                      if (userType == 'teacher') {
                        Navigator.push(
                          context,
                          SlideAnimationRoute(
                            child: TeacherScreen(),
                            slideRight: true,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          SlideAnimationRoute(
                            child: HomeScreen(),
                            slideRight: true,
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
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
                    SizedBox(height: 20),
                    Container(
                      height: 120,
                      child: resuableTextFieldNoPassWord(
                        "Description",
                        Icons.description,
                        descriptionController,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: 200,
                      child: resuableTextFieldNoPassWord(
                        "Number of Days",
                        Icons.calendar_today,
                        daysController,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String name = nameController.text;
                        String description = descriptionController.text;
                        int numberOfDays = int.tryParse(daysController.text) ?? 0;

                        if (name.isNotEmpty && description.isNotEmpty && numberOfDays > 0) {
                          try {
                            await _assignmentService.createAssignment(name, description, numberOfDays);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Assignment created successfully')),
                            );
                            // Clear the text fields after successful assignment creation
                            nameController.clear();
                            descriptionController.clear();
                            daysController.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to create assignment')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill in all the fields')),
                          );
                        }
                      },
                      child: Text('Create Assignment'),
                    ),

                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExistingAssignment(),
                          ),
                        );
                      },
                      child: Text('View Previous Assignments'),
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
