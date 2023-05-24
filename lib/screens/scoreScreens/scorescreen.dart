import 'package:elosystem/screens/scoreScreens/scoreboardProviders/scoreboardProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/color_utils.dart';
import 'leaderboardWidget.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  late ScoreScreenProvider scoreScreenProvider;

  @override
  void initState() {
    super.initState();
    scoreScreenProvider = ScoreScreenProvider();
    scoreScreenProvider.loadLeaderboard();
    scoreScreenProvider.loadLoggedInUserName();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScoreScreenProvider>(
        create: (context) => scoreScreenProvider,
    child: Consumer<ScoreScreenProvider>(builder: (context, state, _) {
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
          child: state.leaderboards.isEmpty
            ? const CircularProgressIndicator() // Show a loading indicator while fetching the user name
              : LeaderboardWidget(leaderboards: state.leaderboards, loggedInUserName: state.loggedInUserName, userType: state.userTypes),
                ));
              }
          ),
        );
  }
}
