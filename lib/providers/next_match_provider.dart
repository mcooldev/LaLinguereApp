import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../models/next_match_model.dart';
import '../services/wp_services/next_match_service.dart';

class NextMatchProvider with ChangeNotifier {
  NextMatchModel? _nextMatch;

  NextMatchModel? get nextMatch => _nextMatch;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchNextMatch() async {
    try {
      //
      _isLoading = true;
      notifyListeners();
      //
      final fetchedNextMatch = await NextMatchService.instance.getNextMatch();
      _nextMatch = fetchedNextMatch;
      //
      notifyListeners();
      //
      _isLoading = false;
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
}
