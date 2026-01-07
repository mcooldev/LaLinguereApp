import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_linguere/pages/otherPages/home.dart';
import 'package:la_linguere/providers/on_boarding_provider.dart';
import 'package:la_linguere/services/firebase_services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/auth_providers/authentication_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../onBoarding/on_boarding_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    ///
    final authStream = FirebaseAuth.instance.authStateChanges();

    ///
    return StreamBuilder(
      stream: authStream,
      builder: (context, snapshot) {
        // waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              children: [
                Text(
                  "Chargement des données...",
                  style: GoogleFonts.manrope(
                    color: blueLinguere,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                CircularProgressIndicator.adaptive(
                  backgroundColor: blueLinguere,
                ),
              ],
            ),
          );
        }
        // has error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erreur lors de la connexion",
              style: GoogleFonts.manrope(
                color: redLaLinguere,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        // has data
        if (snapshot.hasData && snapshot.data != null) {
          return Consumer<LoginProvider>(
            builder: (_, prov, _) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) return;
                //
                await prov.getUserData();
                //
                bool exist = await prov.checkIfUserExists(currentUser.uid);
                //
                if (!exist && context.mounted) {
                  showErrorDialog(context, prov);
                }
              });
              return const Home();
            },
          );
        }
        //
        return Consumer2<LoginProvider, OnBoardingProvider>(
          builder: (_, prov, obProv, _) {
            if (obProv.isFirstTime) {
              return const OnBoardingScreen();
            }
            if (prov.signedAsGuest) {
              return const Home();
            }
            return const OnBoardingScreen();
          },
        );
      },
    );
  }

  Future<dynamic> showErrorDialog(BuildContext context, LoginProvider prov) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "⚠️",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(color: redLaLinguere),
            ),
            //
            const SizedBox(height: 12),
            Text(
              "Vous n'avez pas encore de compte sur La Linguere !",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            //
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        actions: [
          // continue as guest btn
          MaterialButton(
            onPressed: () async {
              navKey.currentState?.pop();
              await AuthService.instance.signOut();
              prov.setSignedAsGuest(true);
            },
            color: Colors.transparent,
            height: 48,
            elevation: 0,
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: BorderSide(color: strokeColor, width: 1),
            ),
            child: Text(
              "Continuer en tant qu'Invité",
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(color: blueLinguere),
            ),
          ),
          //
          const SizedBox(height: 12),
          // create account btn
          MaterialButton(
            onPressed: () async {
              //
              navKey.currentState?.pop();
              await AuthService.instance.signOut();
              navKey.currentState?.pushNamed("/signup");
            },
            color: blueLinguere,
            height: 48,
            elevation: 0,
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: Text(
              "S'inscrire maintenant",
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
