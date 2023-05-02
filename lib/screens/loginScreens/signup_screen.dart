import 'package:elosystem/screens/loginScreens/signin_screen.dart';
import 'package:elosystem/utils/slideAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/auth_service.dart';
import '../../utils/color_utils.dart';

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
            top: MediaQuery.of(context).size.height * 0.45,
            left: 32,
            right: 32,
            child: resuableTextField(
                "Email", Icons.person_3_outlined, false, _emailController),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: 32,
            right: 32,
            child: resuableTextField("UserName", Icons.person_3_outlined, false,
                _userNameController),
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
            child: signInButton(context, false, () async {
              AuthService authService = AuthService.instance();

              try {
                await authService.signUpWithEmailAndPassword(
                  _emailController.text,
                  _passwordTextController.text,
                  _userNameController.text,
                );
                print("User created");
                Navigator.push(
                    context,
                    SlideAnimationRoute(
                        child: SignInScreen(), slideRight: true));
              } catch (error) {
                print("Error creating user: $error");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error creating user: $error")));
              }
            }),
          ),
        ],
      ),
    )));
  }
}
