import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:la_linguere/main.dart';

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  ///
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> initFcm() async {
    //
    await Future.wait([
      //
      fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      ),
      //
      fcm.subscribeToTopic("matches"),
      //
      fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      ),
      //
    ]);

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      if (msg.notification != null) {
        showMsgWhileAppOpened(msg);
        //
        log("Notification reçu : Titre = ${msg.notification!.title}");
        //
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      handleNavigation(msg);
    });
  }

  void handleNavigation(RemoteMessage message) {
    if (message.data['route'] == "/matches") {
      navKey.currentState?.pushNamedAndRemoveUntil(
        "/matches",
        (route) => false,
      );
    }
  }

  FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    try {
      const AndroidInitializationSettings initSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      //
      final DarwinInitializationSettings initSettingsDarwin =
          const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );
      //
      final initSettings = InitializationSettings(
        android: initSettingsAndroid,
        iOS: initSettingsDarwin,
      );
      await fln.initialize(initSettings);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> showMsgWhileAppOpened(RemoteMessage message) async {
    final AndroidNotificationDetails androidNd =
        const AndroidNotificationDetails(
          "Livescore-channelId",
          "Livescore",
          channelDescription: "Livescore notifications",
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    final iosNd = const DarwinNotificationDetails();
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNd,
      iOS: iosNd,
    );
    await fln.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }
}
