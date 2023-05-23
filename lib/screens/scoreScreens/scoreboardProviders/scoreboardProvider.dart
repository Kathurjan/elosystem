import 'package:flutter/cupertino.dart';

import '../../../utils/fire_service/auth_service.dart';

class ScoreScreenProvider with ChangeNotifier {
  final AuthService _authService = AuthService.instance();
  List<Map<String, dynamic>> leaderboards = [];
  late Future<String> loggedInUserName;

  Future<void> loadLoggedInUserName() async {
    loggedInUserName = _authService.getCurrentUserName();
    notifyListeners();
  }

  Future<void> loadLeaderboard() async {
    leaderboards = await _authService.getScore();
    leaderboards.sort((a, b) => b['score'].compareTo(a['score']));
    notifyListeners();
  }
}