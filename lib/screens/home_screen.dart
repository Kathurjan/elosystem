import 'package:elosystem/screens/quizScreens/quiz_screen.dart';
import 'package:elosystem/screens/assignmentScreens/assignment_screen.dart';
import 'package:elosystem/screens/scoreScreens/score_screen.dart';
import 'package:elosystem/screens/loginScreens/signin_screen.dart';
import 'package:elosystem/screens/statsScreens/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/auth_service.dart';
import '../utils/color_utils.dart';
import '../utils/slideAnimation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


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
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: 0,
                child: Column(
                  children: [
                    ReturnButton("Logout", context, () async {
                      Navigator.push(context, SlideAnimationRoute(child: SignInScreen(), slideRight: true)); // Navigate to the screen after successful sign in
                    }
                    ),
                  ]
                ),
              ),
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
                      "Marcus Petersen",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    QrImage(
                      data: "Marcus",
                      size: 100,
                      // You can include embeddedImageStyle Property if you
                      //wanna embed an image from your Asset folder
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        color: Colors.white,
                        size: const Size(
                          100,
                          100,
                        ),
                      ),
                    ),
                  ]
                      .map((widget) => Padding(
                            padding: const EdgeInsets.only(bottom: 16, top: 16),
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
                          Navigator.push(context, SlideAnimationRoute(child: AssignmentScreen(), slideRight: true)); // Navigate to the screen after successful sign in
                        }
                      ),
                      SizedBox(width: 10.0,
                        height: 10.0),
                      RoutingButton("Quiz", context, () async {
                        Navigator.push(context, SlideAnimationRoute(child: QuizScreen(), slideRight: true)); // Navigate to the screen after successful sign in
                      }
                      ),
                      SizedBox(width: 10.0,
                          height: 10.0),
                      // RoutingButton("Score", "path"),
                      RoutingButton("Score", context, () async {
                        Navigator.push(context, SlideAnimationRoute(child: ScoreScreen(), slideRight: true)); // Navigate to the screen after successful sign in
                      }
                      ),
                      SizedBox(width: 10.0,
                          height: 10.0),
                      // RoutingButton("Stats", "path"),
                      RoutingButton("Stats", context, () async {
                        Navigator.push(context, SlideAnimationRoute(child: StatsScreen(), slideRight: true)); // Navigate to the screen after successful sign in
                      }
                      ),
                      // RoutingButton("Quiz", "path"),
                    ],
                  )),
            ],
          )),
    ));
  }
}
