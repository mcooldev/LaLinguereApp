import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  ///
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> initFcm() async {
    //
    await Future.wait([
      fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      ),
      //
      fcm.subscribeToTopic("matches"),
      //
      fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      ),
    ]);
  }
}
