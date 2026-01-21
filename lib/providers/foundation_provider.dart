import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:la_linguere/models/contact_model.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/team_views/history_view.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/team_views/team_u15_view.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/team_views/team_woman_view.dart';
import 'package:url_launcher/url_launcher.dart';

class FoundationProvider with ChangeNotifier {
  final List<Widget> _teamPages = [
    const HistoryView(),
    const TeamWomanView(),
    const TeamU15View(),
  ];

  List<Widget> get teamPages => _teamPages;

  final List<String> _teamPageTitles = ['Histoire', 'Féminine', 'U15'];

  List<String> get teamPageTitles => _teamPageTitles;

  int _teamPageIndex = 0;

  int get teamPageIndex => _teamPageIndex;

  set teamPageIndex(int index) {
    _teamPageIndex = index;
    notifyListeners();
  }

  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  TabController? _tabController;

  TabController? get tabController => _tabController;

  void setTabIndex(int index) {
    _tabIndex = index;
    _tabController?.animateTo(index);
    notifyListeners();
  }

  void resetTabIndex() {
    _tabIndex = 0;
  }

  void initTab(TickerProvider ticker) {
    _tabController = TabController(
      length: 4,
      vsync: ticker,
      initialIndex: _tabIndex,
    );
    _tabController?.addListener(handleTabSelection);
    notifyListeners();
  }

  void handleTabSelection() {
    if (_tabController != null) {
      _tabIndex = _tabController!.index;
      notifyListeners();
    }
  }

  /// Logo partners
  final List<String> _logoPartners = [
    "assets/logo_partners/amsa.png",
    "assets/logo_partners/com_st_louis.png",
    "assets/logo_partners/invictus.png",
    "assets/logo_partners/leral_tv.png",
    "assets/logo_partners/neptune.png",
    "assets/logo_partners/o_royal.png",
    "assets/logo_partners/ohgarage.png",
    "assets/logo_partners/outarde.png",
    "assets/logo_partners/supdeco.png",
  ];

  List<String> get logoPartners => _logoPartners;

  final InfiniteScrollController scrollController = InfiniteScrollController();

  bool _isAnimating = false;

  bool get isAnimating => _isAnimating;

  void startLoop() {
    if (!_isAnimating) {
      _isAnimating = true;
      loop();
    }
  }

  void loop() async {
    if (scrollController.hasClients) {
      await scrollController.nextItem(
        duration: const Duration(seconds: 2),
        curve: Curves.linear,
      );
      loop();
    } else {
      _isAnimating = false;
    }
  }

  /// Info contact
  final List<ContactModel> _infoContact = [
    ContactModel(
      label: 'Adresse',
      content: 'Linguère, Saint-Louis',
      iconData: CupertinoIcons.map,
      onTap: onTapLocation,
    ),
    ContactModel(
      label: 'Adresse mail',
      content: 'infos@lalinguere.com',
      iconData: CupertinoIcons.at,
      onTap: onTapMail,
    ),
    ContactModel(
      label: 'Téléphone',
      content: '+221 77 200 69 87',
      iconData: CupertinoIcons.phone,
      onTap: onTapPhone,
    ),
  ];

  List<ContactModel> get infoContact => _infoContact;

  static void onTapLocation() async {
    final url = Uri.parse('https://maps.app.goo.gl/D6mHhE7Teqg7k12N9');
    if (!await launchUrl(url)) {
      log('Could not launch location: $url');
    }
  }

  static void onTapMail() async {
    final uri = Uri(scheme: 'mailto', path: 'infos@lalinguere.com');
    if (!await launchUrl(uri)) {
      log('Could not launch mail: $uri');
    }
  }

  static void onTapPhone() async {
    final uri = Uri(scheme: 'tel', path: '+221772006987');
    if (!await launchUrl(uri)) {
      log('Could not launch phone: $uri');
    }
  }

  /// Disposer
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
