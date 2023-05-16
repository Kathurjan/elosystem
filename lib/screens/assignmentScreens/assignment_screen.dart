import 'package:elosystem/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/slideAnimation.dart';
import '../teacher_screen.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final AuthService _authService = AuthService.instance(); // Create an instance of the AuthService class

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
                      String userType = await _authService.getUserType(); // Get the user's role from the AuthService
                      if (userType == 'teacher') {
                        // Check if the user is a teacher
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
                      height: 120, // Increased height for description
                      child: resuableTextFieldNoPassWord(
                        "Description",
                        Icons.description,
                        descriptionController,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 40, // Decreased height for days
                      child: resuableTextFieldNoPassWord(
                        "Number of Days",
                        Icons.calendar_today,
                        daysController,
                      ),
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
