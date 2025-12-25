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
}
