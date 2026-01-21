import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../models/next_match_model.dart';
import '../services/wp_services/next_match_service.dart';

class NextMatchProvider with ChangeNotifier {
  NextMatchModel? _nextMatch;

  NextMatchModel? get nextMatch => _nextMatch;
  bool _isLoading = false;
  bool _isLoaded = false;

  bool get isLoading => _isLoading;

  bool get isLoaded => _isLoaded;

  Future<void> fetchNextMatch() async {
    //
    if (_isLoaded) return;
    //
    _isLoading = true;
    notifyListeners();
    try {
      //
      final fetchedNextMatch = await NextMatchService.instance.getNextMatch();
      _nextMatch = fetchedNextMatch;
      //
      _isLoading = false;
      _isLoaded = true;
      notifyListeners();
      //
    } catch (e) {
      log(e.toString());
      //
      _isLoading = false;
      notifyListeners();
      //
    }
  }

  Future<void> refreshNextMatch() async {
    _isLoaded = false;
    await fetchNextMatch();
  }

  /// U15
  NextMatchU15Model? _nextMatchU15;

  NextMatchU15Model? get nextMatchU15 => _nextMatchU15;
  bool _isLoadingU15 = false;
  bool _isLoadedU15 = false;

  bool get isLoadingU15 => _isLoadingU15;

  bool get isLoadedU15 => _isLoadedU15;
  Future<void> fetchNextMatchU15() async {
    //
    if (_isLoadedU15) return;
    //
    _isLoadingU15 = true;
    notifyListeners();
    try {
      //
      final fetchedNextMatch = await NextMatchService.instance.getNextMatchU15();
      _nextMatchU15 = fetchedNextMatch;
      //
      _isLoadingU15 = false;
      _isLoadedU15 = true;
      notifyListeners();
      //
    } catch (e) {
      log(e.toString());
      //
      _isLoadingU15 = false;
      notifyListeners();
      //
    }
  }

  Future<void> refreshNextMatchU15() async {
    _isLoadedU15 = false;
    await fetchNextMatchU15();
  }

  /// Woman team

  NextMatchWomanModel? _nextMatchWoman;

  NextMatchWomanModel? get nextMatchWoman => _nextMatchWoman;
  bool _isLoadingWoman = false;
  bool _isLoadedWoman = false;

  bool get isLoadingWoman => _isLoadingWoman;

  bool get isLoadedWoman => _isLoadedWoman;
  Future<void> fetchNextMatchWoman() async {
    //
    if (_isLoadedWoman) return;
    //
    _isLoadingWoman = true;
    notifyListeners();
    try {
      //
      final fetchedNextMatch = await NextMatchService.instance.getNextMatchWoman();
      _nextMatchWoman = fetchedNextMatch;
      //
      _isLoadingWoman = false;
      _isLoadedWoman = true;
      notifyListeners();
      //
    } catch (e) {
      log(e.toString());
      //
      _isLoadingWoman = false;
      notifyListeners();
      //
    }
  }

  Future<void> refreshNextMatchWoman() async {
    _isLoadedWoman = false;
    await fetchNextMatchWoman();
  }

}
