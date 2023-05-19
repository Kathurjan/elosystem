import 'package:elosystem/DTO/questionaireDTO.dart';
import 'package:elosystem/screens/scoreScreens/score_screen.dart';
import 'package:elosystem/screens/loginScreens/signin_screen.dart';
import 'package:elosystem/screens/statsScreens/stats_screen.dart';
import 'package:flutter/cupertino.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/fire_service/auth_service.dart';
import '../utils/color_utils.dart';
import '../utils/slideAnimation.dart';
import 'assignmentScreens/student/listOfAssigment_student.dart';
import 'assignmentScreens/teacher/assignment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService.instance();
  Questionaire questionaire = new Questionaire(quizQuestion: [QuizQuestion(question: "question", answers: [{"answer": false}]), QuizQuestion(question: "question", answers: [{"answer": false}]), QuizQuestion(question: "question", answers: [{"answer": false}])]);

  @override
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
          child: FutureBuilder<String>(
            future: authService.getCurrentUserName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final studentId = authService.getCurrentUserId();
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: 0,
                      child: signOutButton("Sign out", context, () async {
                        AuthService authService = AuthService.instance();
                        try {
                          await authService.signOut();
                          Navigator.pushReplacement(
                            context,
                            SlideAnimationRoute(
                              child: const SignInScreen(),
                              slideRight: true,
                            ),
                          );
                        } catch (error) {
                          print("Error signing out: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Error signing out: $error")),
                          );
                        }
                      }),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          AbsorbPointer(
                            absorbing: false,
                            child: InkWell(
                              onTap: () {
                                print('Profile picture tapped');
                                authService.updateProfilePicture();
                                setState(() {});
                              },
                              child: authService.getCurrentUser()!.photoURL !=
                                      null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        authService.getCurrentUser()!.photoURL!,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/images/placeholder-profile.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          Text(
                            snapshot.data ?? '',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          QrImage(
                            data: studentId!,
                            size: 100,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              color: Colors.white,
                              size: const Size(100, 100),
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
                              SlideAnimationRoute(
                                child: const ListOfAssignmentStudent(),
                                slideRight: true,
                              ),
                            );
                          }),
                          const SizedBox(width: 10.0, height: 10.0),
                          RoutingButton("Quiz", context, () async {
                            Navigator.pushReplacement(
                              context,
                              SlideAnimationRoute(
                                child: const AssignmentScreen(),
                                slideRight: true,
                              ),
                            );
                          }),
                          const SizedBox(width: 10.0, height: 10.0),
                          RoutingButton("Score", context, () async {
                            Navigator.pushReplacement(
                              context,
                              SlideAnimationRoute(
                                child: const ScoreScreen(),
                                slideRight: true,
                              ),
                            );
                          }),
                          const SizedBox(width: 10.0, height: 10.0),
                          RoutingButton("Stats", context, () async {
                            Navigator.pushReplacement(
                              context,
                              SlideAnimationRoute(
                                child: const StatsScreen(),
                                slideRight: true,
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
