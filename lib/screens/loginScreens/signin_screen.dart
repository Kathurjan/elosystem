// ignore_for_file: use_build_context_synchronously

import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/screens/home_screen.dart';
import 'package:elosystem/screens/loginScreens/signup_screen.dart';
import 'package:elosystem/utils/slideAnimation.dart';
import 'package:elosystem/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/auth_service.dart';
import '../teacher_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
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
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.5 - 80,
            child: Image.asset(
              'assets/images/easv-logo-transparent.png',
              width: 160,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: 32,
            right: 32,
            child: resuableTextField(
                "Email", Icons.person_3_outlined, false, _emailController),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.65,
            left: 32,
            right: 32,
            child: resuableTextField("PassWord", Icons.lock_clock_outlined,
                true, _passwordTextController),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.75,
            left: 32,
            right: 32,
            child: signInButton(context, true, () async {
              AuthService authService = AuthService();
              try {
                await authService.signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordTextController.text,
                );
                final userType = await authService.getUserType();
                if (userType == 'student') {
                  Navigator.push(
                      context,
                      SlideAnimationRoute(
                          child: HomeScreen(), slideRight: true));
                } else if (userType == 'teacher') {
                  Navigator.push(
                      context,
                      SlideAnimationRoute(
                          child: const TeacherScreen(), slideRight: true));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Error: User type not recognized")));
                }
                print("User signed in");
              } catch (error) {
                print("Error signing in user: $error");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error signing in user: $error")));
              }
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.85,
            left: 0,
            right: 0,
            child: signUpOption(),
          ), //
        ],
      ),
    )));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            // not sure if i should use push or pushReplacement here? need to discuss with rasmus maybe?
            Navigator.push(
                context,
                SlideAnimationRoute(
                    child: const SignUpScreen(), slideRight: false));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
