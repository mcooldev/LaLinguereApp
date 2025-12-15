import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:la_linguere/models/news_model.dart';

import '../services/wp_services/news_service.dart';

class NewsProvider with ChangeNotifier {
  ///
  final monthList = [
    '',
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];

  String dateFormat(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${monthList[date.month]} ${date.year}";
  }

  ///
  final List<NewsModel> _newsList = [];

  List<NewsModel> get newsList => [..._newsList];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ///
  Future fetchAllNews() async {
    try {
      //
      _isLoading = true;
      notifyListeners();
      //
      final news = await NewsService.instance.getNews();
      _newsList.clear();
      _newsList.addAll(news);
      //
      _isLoading = false;
      notifyListeners();
      //
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
