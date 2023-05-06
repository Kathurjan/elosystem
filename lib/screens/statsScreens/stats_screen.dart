import 'package:elosystem/screens/home_screen.dart';
import 'package:elosystem/screens/loginScreens/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/slideAnimation.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State {

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
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05,
                    left: 0,
                    child: Column(
                        children: [
                          ReturnButton("Back", context, () async {
                            Navigator.push(context, SlideAnimationRoute(
                                child: HomeScreen(),
                                slideRight: true)); // Navigate to the screen after successful sign in
                          }
                          ),
                        ]
                    ),
                  ),
                ],
              )),
        ));
  }
}



