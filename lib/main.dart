import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:la_linguere/pages/authentication/auth_gate.dart';
import 'package:la_linguere/pages/authentication/forget_password.dart';
import 'package:la_linguere/pages/authentication/login.dart';
import 'package:la_linguere/pages/authentication/otp_screen.dart';
import 'package:la_linguere/pages/authentication/signup.dart';
import 'package:la_linguere/pages/onBoarding/on_boarding_screen.dart';
import 'package:la_linguere/pages/onBoarding/splash.dart';
import 'package:la_linguere/pages/otherPages/foundation.dart';
import 'package:la_linguere/pages/otherPages/home.dart';
import 'package:la_linguere/pages/otherPages/matches.dart';
import 'package:la_linguere/pages/otherPages/profile.dart';
import 'package:la_linguere/pages/otherPages/support.dart';
import 'package:la_linguere/providers/all_rank_provider.dart';
import 'package:la_linguere/providers/auth_providers/authentication_provider.dart';
import 'package:la_linguere/providers/foundation_provider.dart';
import 'package:la_linguere/providers/matches_provider.dart';
import 'package:la_linguere/providers/membership_provider.dart';
import 'package:la_linguere/providers/navigation_provider.dart';
import 'package:la_linguere/providers/news_provider.dart';
import 'package:la_linguere/providers/next_match_provider.dart';
import 'package:la_linguere/providers/on_boarding_provider.dart';
import 'package:la_linguere/providers/ranking_provider.dart';
import 'package:la_linguere/providers/support_provider.dart';
import 'package:la_linguere/services/firebase_services/fcm_service.dart';
import 'package:la_linguere/services/wp_services/config.dart';
import 'package:la_linguere/utils/theme/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';

import 'firebase_options.dart';

///
final navKey = GlobalKey<NavigatorState>();
final config = Config.instance;
final fcm = FcmService.instance;

///
@pragma('vm:entry-point')
Future<void> fcmMessageHandler(RemoteMessage msg) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //
  log("Message reçu en avant-plan : ${msg.messageId}");
}

@pragma("vm:entry-point")
void notificationTapBackground(NotificationResponse response) {
  log("Notification tap background : ${response.payload}");
}

///

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //
  await FirebaseAppCheck.instance.activate(
    providerApple: const AppleDebugProvider(),
    providerAndroid: const AndroidDebugProvider(),
  );
  //
  FirebaseMessaging.onBackgroundMessage(fcmMessageHandler);
  //
  await fcm.initNotification();
  //
  final client = await Recaptcha.fetchClient(config.recaptchaSiteKey);
  //
  runApp(MyApp(client: client));
  //
  Future.delayed(const Duration(milliseconds: 500), () {
    fcm.initFcm();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});

  final RecaptchaClient client;

  @override
  Widget build(BuildContext context) {
    ///
    final appTheme = AppTheme();

    ///
    return MultiProvider(
      providers: [
        //
        ChangeNotifierProvider(
          create: (_) => OnBoardingProvider()..setFirstTime(),
        ),
        //
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        //
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(create: (_) => NextMatchProvider()),
        //
        ChangeNotifierProvider(create: (_) => FoundationProvider()),
        //
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => AllRankProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
        //
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        //
        ChangeNotifierProvider(create: (_) => MembershipProvider()),
      ],
      child: MaterialApp(
        title: 'La Linguere',
        debugShowCheckedModeBanner: false,
        theme: appTheme.theme,
        navigatorKey: navKey,
        routes: {
          '/': (_) => const Splash(),
          '/onBoarding': (_) => const OnBoardingScreen(),
          // authentication
          '/login': (_) => const Login(),
          '/signup': (_) => const Signup(),
          '/forgetPassword': (_) => const ForgetPassword(),
          '/otpScreen': (_) => const OtpScreen(),
          '/authGate': (_) => const AuthGate(),
          //
          '/home': (_) => const Home(),
          '/matches': (_) => const Matches(),
          '/profile': (_) => const Profile(),
          '/support': (_) => const Support(),
          '/foundation': (_) => const Foundation(),
          //
        },
      ),
    );
  }
}
