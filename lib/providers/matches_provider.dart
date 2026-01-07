import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:la_linguere/services/other_service/results_service.dart';

import '../models/calendar_model.dart';
import '../models/result_model.dart';
import '../services/wp_services/calendar_service.dart';

class MatchesProvider with ChangeNotifier {
  TabController? _tabController;

  TabController? get tabController => _tabController;

  set tabController(TabController? tabController) {
    _tabController = tabController;
    notifyListeners();
  }

  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  void initTabController(TickerProvider vsync) {
    _tabController = TabController(
      length: 3,
      vsync: vsync,
      initialIndex: _tabIndex,
    );
    _tabController!.addListener(handleTabSelection);
    notifyListeners();
    //
  }

  void resetTabIndex() {
    _tabIndex = 0;
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    _tabController?.animateTo(index);
    notifyListeners();
  }

  void handleTabSelection() {
    if (_tabController != null) {
      _tabIndex = _tabController!.index;
      notifyListeners();
    }
  }

  String get appBarTitle {
    if (_tabController == null) return "Prochain match";
    switch (_tabController!.index) {
      case 0:
        return "Prochain match";
      case 1:
        return "Dernier match joué";
      case 2:
        return "Classement";
      default:
        return "Prochain match";
    }
  }

  ///
  final List<String> _matchesViewTitles = ['Ligue 1', 'Coupe du Sénégal'];

  List<String> get matchesViewTitles => _matchesViewTitles;

  int _matchesViewIndex = 0;

  int get matchesViewIndex => _matchesViewIndex;

  set matchesViewIndex(int index) {
    _matchesViewIndex = index;
    notifyListeners();
  }

  bool _isLoading = false;
  bool _isLoaded = false;

  bool get isLoading => _isLoading;

  bool get isLoaded => _isLoaded;

  /// fetch calendar
  final List<CalendarModel> _calendarList = [];

  List<CalendarModel> get calendarList => [..._calendarList];

  ///
  final monthList = [
    '',
    'Jan.',
    'Fév.',
    'Mars',
    'Avr.',
    'Mai',
    'Juin',
    'Juil',
    'Août',
    'Sept.',
    'Oct.',
    'Nov.',
    'Déc.',
  ];

  String dateFormat(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${monthList[date.month]} ${date.year}";
  }

  ///

  Future<void> fetchCalendar() async {
    if (_isLoaded) return;
    //
    _isLoading = true;
    notifyListeners();
    //
    try {
      final calendar = await CalendarService.instance.fetchCalendar();
      _calendarList.clear();
      _calendarList.addAll(calendar);
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

  Future<void> refreshCalendar() async {
    _isLoaded = false;
    await fetchCalendar();
  }

  /// Results data
  final List<ResultModel> _resultsList = [];

  List<ResultModel> get resultsList => [..._resultsList];

  late ResultModel linguereResult;

  Future<void> fetchResults() async {
    if (_isLoaded) return;
    //
    _isLoading = true;
    notifyListeners();
    //
    try {
      final fetchedResults = await ResultsService.instance.getResults();
      _resultsList.clear();
      _resultsList.addAll(fetchedResults);
      //
      linguereResult = _resultsList.firstWhere(
        (r) =>
            (r.teamHomeName == "ASC Linguère" ||
            r.teamAwayName == "ASC Linguère"),
        orElse: () => ResultModel(
          teamHomeName: "",
          teamAwayName: "",
          teamHomeScore: "0",
          teamAwayScore: "0",
          teamHomeLogo: '',
          teamAwayLogo: '',
        ),
      );
      notifyListeners();
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

  Future<void> refreshResults() async {
    _isLoaded = false;
    await fetchResults();
  }

  /// Disposer
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
