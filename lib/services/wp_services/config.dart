import 'package:la_linguere/main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Config {
  Config._();

  static final Config instance = Config._();

  ///
  final String baseUrl = "lalinguere.net";

  final String _oneSignalAppId = "68462405-b7e6-4b73-b511-2ef38edbebac";

  ///
  void initOneSignal() {
    OneSignal.initialize(_oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);
    //
    OneSignal.User.addTagWithKey("livescore", true);
    Future.microtask(() {
      if (navKey.currentState != null) {
        navKey.currentState?.pushNamedAndRemoveUntil(
          '/matches',
          (route) => false,
        );
      }
    });
  }
}
