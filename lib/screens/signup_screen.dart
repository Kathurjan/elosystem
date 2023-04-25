import 'package:elosystem/screens/signin_screen.dart';
import 'package:elosystem/utils/slideAnimation.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/resuable_widgets.dart';
import '../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
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
            ),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5 - 80,
              child: Image.asset(
                'assets/images/easv-logo-transparent.png',
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.45,
              left: 32,
              right: 32,
              child: resuableTextField(
                  "Email", Icons.person_3_outlined, false, _emailController),
            ),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.55,
              left: 32,
              right: 32,
              child: resuableTextField(
                  "UserName", Icons.person_3_outlined, false, _userNameController),
            ),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.65,
              left: 32,
              right: 32,
              child: resuableTextField(
                  "PassWord", Icons.lock_clock_outlined, true,
                  _passwordTextController),
            ),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.75,
              left: 32,
              right: 32,
              child: signInButton(context, false, () {
                // not sure if i should use push or pushReplacement here?
                Navigator.push(context,SlideAnimationRoute(child: SignInScreen(), slideRight: true));//TODO: Add sign up logic
              }),
            ),
          ],
        ),
      );
  }
}
