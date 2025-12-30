import 'package:flutter/material.dart';
import 'package:la_linguere/pages/authentication/forget_password.dart';
import 'package:la_linguere/pages/authentication/login.dart';
import 'package:la_linguere/pages/authentication/otp_screen.dart';
import 'package:la_linguere/pages/authentication/signup.dart';
import 'package:la_linguere/pages/onBoarding/on_boarding_screen.dart';
import 'package:la_linguere/pages/onBoarding/splash.dart';
import 'package:la_linguere/pages/otherPages/home.dart';
import 'package:la_linguere/pages/otherPages/matches.dart';
import 'package:la_linguere/pages/otherPages/support.dart';
import 'package:la_linguere/providers/all_rank_provider.dart';
import 'package:la_linguere/providers/foundation_provider.dart';
import 'package:la_linguere/providers/matches_provider.dart';
import 'package:la_linguere/providers/navigation_provider.dart';
import 'package:la_linguere/providers/news_provider.dart';
import 'package:la_linguere/providers/next_match_provider.dart';
import 'package:la_linguere/providers/on_boarding_provider.dart';
import 'package:la_linguere/providers/ranking_provider.dart';
import 'package:la_linguere/providers/support_provider.dart';
import 'package:la_linguere/services/wp_services/config.dart';
import 'package:la_linguere/utils/theme/theme_data.dart';
import 'package:provider/provider.dart';

///
final navKey = GlobalKey<NavigatorState>();
final config = Config.instance;

///

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  //
  config.initOneSignal();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///
    final appTheme = AppTheme();

    ///
    return MultiProvider(
      providers: [
        //
        ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
        //
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        //
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(create: (_) => NextMatchProvider()),
        //
        ChangeNotifierProvider(create: (_) => FoundationProvider()),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => AllRankProvider()),
        //
        ChangeNotifierProvider(create: (_) => SupportProvider()),
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
          //
          '/home': (_) => const Home(),
          '/matches': (_) => const Matches(),
          '/support': (_) => const Support(),
        },
      ),
    );
  }
}
