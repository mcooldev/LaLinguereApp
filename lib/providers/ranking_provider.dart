import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/ranking_model.dart';
import '../services/wp_services/ranking_service.dart';

class RankingProvider with ChangeNotifier {
  RankingModel? _ranking;

  RankingModel? get ranking => _ranking;
  bool _isLoading = false;
  bool _isLoaded = false;

  bool get isLoading => _isLoading;

  bool get isLoaded => _isLoaded;

  Future fetchRanking() async {
    if (_isLoaded) return;
    //
    _isLoading = true;
    notifyListeners();
    try {
      //
      final fetchedRanking = await RankingService.instance.getRanking();
      _ranking = fetchedRanking;
      //
      _isLoading = false;
      _isLoaded = true;
      notifyListeners();
      //
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshRanking() async {
    _isLoaded = false;
    await fetchRanking();
  }
}
