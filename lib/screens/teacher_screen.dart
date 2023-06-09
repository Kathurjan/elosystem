import 'package:elosystem/screens/assignmentScreens/teacher/teachAssignmentProviders/teacherAssignmentProvider.dart';
import 'package:elosystem/screens/quizScreens/questionnaireListScreen.dart';
import 'package:elosystem/screens/quizScreens/questionnaireProvideClasses/teacherQuestionnaireProviders.dart';
import 'package:elosystem/screens/scoreScreens/scoreboardProviders/scoreboardProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:provider/provider.dart';
import '../utils/fire_service/auth_service.dart';
import '../utils/color_utils.dart';
import 'assignmentScreens/teacher/assignment_screen.dart';
import '../screens/scoreScreens/scorescreen.dart';
import '../screens/loginScreens/signin_screen.dart';
import '../screens/qr_scenes/QRScannerScreen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  AuthService authService = AuthService.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: () => {
              authService.signOut(),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              )
            },
          )
        ],
        centerTitle: true,
        title: const Text('Home Menu'),
        backgroundColor: hexStringToColor("fdbb2d"),
        automaticallyImplyLeading: false,
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
          padding: const EdgeInsets.only(left: 00.0, right: 00.0),
          child: FutureBuilder<String>(
            future: authService.getCurrentUserName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/placeholder-profile.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            snapshot.data ?? '',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]
                            .map((widget) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, top: 16),
                          child: widget,
                        ))
                            .toList(),
                      ),

                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.55,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          RoutingButton("Assignment", context, () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssignmentScreen()
                              ),
                            );
                          }),
                          SizedBox(width: 10.0, height: 10.0),
                          RoutingButton("Quiz", context, () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionnaireListScreen()
                              ),
                            );
                          }),
                          SizedBox(width: 10.0, height: 10.0),
                          RoutingButton("Score", context, () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScoreScreen()
                              ),
                            );
                          }),
                          SizedBox(width: 10.0, height: 10.0),
                          RoutingButton("QR Scanner", context, () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRScannerScreen(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
