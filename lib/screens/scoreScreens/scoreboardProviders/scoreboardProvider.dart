import 'package:flutter/cupertino.dart';

import '../../../utils/fire_service/auth_service.dart';

class ScoreScreenProvider with ChangeNotifier {
  final AuthService _authService = AuthService.instance();
  List<Map<String, dynamic>> leaderboards = [];
  String loggedInUserName = "";
  String userTypes = "";

  Future<void> loadLoggedInUserName() async {
    final username = _authService.getCurrentUserName() as String;
    loggedInUserName = username;
    notifyListeners();
  }

  Future<void> loadLeaderboard() async {
    leaderboards = await _authService.getScore();
    leaderboards.sort((a, b) => b['score'].compareTo(a['score']));
    notifyListeners();
  }


  Future<void> loadUserType() async {
    try {
      final userType = await _authService.getUserType();
      userTypes = userType;
      notifyListeners();
    } catch (e) {
      print('Error retrieving user type: $e');
    }
  }
}