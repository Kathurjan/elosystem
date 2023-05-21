import 'package:elosystem/screens/home_screen.dart';
import 'package:elosystem/screens/teacher_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/slideAnimation.dart';
import 'leaderboardWidget.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final AuthService authService = AuthService.instance();
  List<Map<String, dynamic>> leaderboards = [];
  String loggedInUserName = '';

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
    loadLoggedInUserName();
  }

  Future<void> loadLoggedInUserName() async {
    final userName = await authService.getCurrentUserName();
    setState(() {
      loggedInUserName = userName;
    });
  }

  Future<void> loadLeaderboard() async {
    leaderboards = await authService.getScore();
    leaderboards.sort((a, b) => b['score'].compareTo(a['score']));
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: hexStringToColor("fdbb2d"),
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
        child: loggedInUserName.isEmpty
            ? const CircularProgressIndicator() // Show a loading indicator while fetching the user name
            : LeaderboardWidget(leaderboards: leaderboards, loggedInUserName: loggedInUserName),
      ),
    );
  }
}

