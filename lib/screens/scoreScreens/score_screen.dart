import 'package:elosystem/screens/home_screen.dart';
import 'package:elosystem/screens/teacher_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/slideAnimation.dart';


class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final AuthService _authService = AuthService.instance(); // Create an instance of the AuthService class

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
          padding: const EdgeInsets.only(left: 00.0, right: 00.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: 0,
                child: Column(
                  children: [
                    ReturnButton("Back", context, () async {
                      String userType = await _authService.getUserType(); // Get the user's role from the AuthService
                      if (userType == 'teacher') { // Check if the user is a teacher
                        Navigator.pushReplacement(
                          context,
                          SlideAnimationRoute(
                            child: TeacherScreen(),
                            slideRight: true,
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
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
            ],
          ),
        ),
      ),
    );
  }
}
