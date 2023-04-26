import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          child: Column(children: [
            Image.asset(
              "assets/images/placeholder-profile.png",
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            Text(
              "Name",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              "assets/images/QR-placeholder.png",
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ]),
        ),
      ],
    ));
  }
}
