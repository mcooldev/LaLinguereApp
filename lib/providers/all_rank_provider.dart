import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:la_linguere/models/all_rank_model.dart';
import 'package:la_linguere/services/other_service/all_rank_service.dart';

class AllRankProvider with ChangeNotifier {
  final List<AllRankModel> _standingList = [];

  List<AllRankModel> get standingList => [..._standingList];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> getAllStanding() async {
    if (_isLoaded) return;
    //
    _isLoading = true;
    notifyListeners();
    try {
      //
      final fetchedStanding = await AllRankService.instance.fetchAllRank();
      _standingList.clear();
      _standingList.addAll(fetchedStanding);
      //
      _isLoading = false;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> refresh() async {
    _isLoaded = false;
    await getAllStanding();
  }
}
