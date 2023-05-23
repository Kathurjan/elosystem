import 'package:elosystem/screens/home_screen.dart';
import 'package:elosystem/screens/teacher_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/resuable_widgets.dart';
import '../../utils/color_utils.dart';
import '../../utils/fire_service/auth_service.dart';
import '../../utils/slideAnimation.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboards;
  final String loggedInUserName;
  final String userType;

  const LeaderboardWidget({Key? key, required this.leaderboards, required this.loggedInUserName, required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leaderboards.length,
      itemBuilder: (context, index) {
        final leaderboard = leaderboards[index];
        final leaderboardName = leaderboard['userName'];
        final leaderboardScore = leaderboard['score'];
        final position = index + 1;
        Color backgroundColor;
        Color textColor;

        // Set background color and text color based on position
        if (position == 1) {
          backgroundColor = Colors.amber;
          textColor = Colors.white;
        } else if (position == 2) {
          backgroundColor = Colors.grey;
          textColor = Colors.white;
        } else if (position == 3) {
          backgroundColor = Colors.brown;
          textColor = Colors.white;
        } else {
          backgroundColor = Colors.white;
          textColor = Colors.black;
        }

        String displayedName = leaderboardName;

        if (userType == 'student') {
          if (leaderboardName != loggedInUserName) {
            displayedName = generateAnonymousName();
          }
        }


        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$position.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
              Text(
                displayedName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
              Text(
                leaderboardScore.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String generateAnonymousName() {
    // Implement your logic here to generate an anonymous or random name
    // For example, you can use a package like faker: https://pub.dev/packages/faker
    // to generate random names
    return 'Anonymous'; // Replace this with your logic to generate anonymous or random names
  }
}
