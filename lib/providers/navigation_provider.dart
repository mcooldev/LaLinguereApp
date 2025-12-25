import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants/app_colors.dart';

class NavigationProvider with ChangeNotifier {
  /// Navigation items
  final _navItems = [
    CupertinoIcons.home,
    Icons.sports_soccer_rounded,
    CupertinoIcons.tickets,
    CupertinoIcons.flag,
    CupertinoIcons.person,
  ];

  List<IconData> get navItems => _navItems;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// navigate with fade transition
  void navigateWithFadeTransition(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, lastAnimation) => page,
        transitionsBuilder: (context, animation, lastAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  /// URL launcher for buying ticket on diotali event

  Future<void> goToUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      log("Could not launch diotali event url : $url");
    }
  }

  /// show bottom sheet
  void showBottomSheet({
    required BuildContext context,
    required void Function() onTapBtn,
    required String btnText,
    required String title,
    required String bodyContent,
    required Widget widget,
  }) async {
    //
    final theme = Theme.of(context);
    //
    //
    await showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // images row
            widget,
            const SizedBox(height: 32),

            // title
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // body text
            Text(
              bodyContent,
              style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // btn redirection
            MaterialButton(
              onPressed: onTapBtn,
              color: blueLinguere,
              height: 48,
              elevation: 0,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    btnText,
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    CupertinoIcons.arrow_up_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //

  }

  /// Greetings
  DateTime now = DateTime.now();
  String get greeting {
    if (now.hour < 12) {
      return 'Bonjour 🌞';
    } else if (now.hour < 18) {
      return 'Bon-après-midi ☀️';
    } else {
      return 'Bonsoir 🌙';
    }
  }



}
