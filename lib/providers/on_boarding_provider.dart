import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider with ChangeNotifier {
  ///
  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;


  // Set the user see the on boarding
  Future<void> setFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final haveSeen = prefs.getBool('onBoarding') ?? false;
    _isFirstTime = !haveSeen;
    notifyListeners();
  }

  // Complete on boarding
  Future<void> completeOnBoarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onBoarding', true);
    _isFirstTime = false;
    notifyListeners();
  }
}
