import 'package:elosystem/reusable_widgets/resuable_widgets.dart';
import 'package:elosystem/screens/signup_screen.dart';
import 'package:elosystem/utils/slideAnimation.dart';
import 'package:elosystem/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../utils/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
                .height * 0.55,
            left: 32,
            right: 32,
            child: resuableTextField(
                "Email", Icons.person_3_outlined, false, _emailController),
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
                print("User signed in");
                Navigator.push(context, SlideAnimationRoute(child: HomeScreen(), slideRight: true)); // Navigate to the screen after successful sign in
              } catch (error) {
                print("Error signing in user: $error");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error signing in user: $error")));
              }
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.85,
            left: 0,
            right: 0,
            child: signUpOption(),
          ),//

        ],
      ),
    );
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
            Navigator.push(context, SlideAnimationRoute(child: SignUpScreen(), slideRight: false));
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
