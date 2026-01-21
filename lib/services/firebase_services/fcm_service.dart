import 'dart:developer';
import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:la_linguere/main.dart';

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  ///
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> initFcm() async {
    RemoteMessage? remoteMessage = await fcm.getInitialMessage();
    if (remoteMessage != null) {
      handleNavigation(remoteMessage);
    }
    //
    final permission = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      //
      bool canSubscribe = true;
      //
      if (Platform.isIOS) {
        String? apnsToken = await fcm.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 3));
          apnsToken = await fcm.getAPNSToken();
        }
        if (apnsToken != null) {
          log("✅ APNS reçu : $apnsToken");
          canSubscribe = true;
        } else {
          log("❌ APNS toujours null - Abonnement impossible");
          canSubscribe = false;
        }
      } else {
        log('🤖 Android détecté');
      }
      //
      if (canSubscribe) {
        await fcm.subscribeToTopic("matches");
      }
    }
    //
    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      if (msg.notification != null) {
        showMsgWhileAppOpened(msg);
        //
        log("Notification reçu : Titre = ${msg.notification!.title}");
        //
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      if (msg.notification != null) {
        handleNavigation(msg);
        //
        AppBadgePlus.updateBadge(0);
      }
    });
  }

  void handleNavigation(RemoteMessage message) {
    if (message.data['route'] == "/matches") {
      navKey.currentState?.pushNamedAndRemoveUntil(
        "/matches",
        (route) => false,
      );
      //
      AppBadgePlus.updateBadge(0);
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
      await fln.initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        onDidReceiveNotificationResponse: (response) {
          if (response.payload != null) {
            navKey.currentState?.pushNamedAndRemoveUntil(
              "/matches",
              (route) => false,
            );
          }
        },
      );
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
      payload: "/matches",
      notificationDetails,
    );
  }
}
