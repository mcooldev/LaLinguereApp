import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/main.dart';
import 'package:la_linguere/providers/on_boarding_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers/authentication_provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    ///
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final obProvider = Provider.of<OnBoardingProvider>(context, listen: false);

    ///
    return Scaffold(
      //
      extendBodyBehindAppBar: true,
      // app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.only(right: 20),
        // log in as guest
        actions: [
          MaterialButton(
            onPressed: () {
              loginProvider.setSignedAsGuest(true);
              obProvider.completeOnBoarding();
              navKey.currentState?.pushNamedAndRemoveUntil(
                '/authGate',
                (route) => false,
              );
            },
            color: Colors.white.withValues(alpha: 0.1),
            elevation: 0,
            height: 48,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Invité',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  CupertinoIcons.arrow_right,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),

      // body content
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgWithPattern.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// content without 3 players images
            Column(
              children: [
                const SizedBox(height: 120),
                // headline
                Text(
                  'Suivez les activités du club La Linguere sur notre application ⚽️',
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // body text
                Text(
                  'Ne manquez plus les matchs, les informations du club et les scores !',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 32),

                // google sign in btn
                MaterialButton(
                  onPressed: () async {
                    await loginProvider.signWithGoogle(context);
                  },
                  color: Colors.black,
                  height: 48,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 22,
                        child: Image.asset('assets/google_logo.png'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Continuer avec google',
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // or
                const Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.white24),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Ou', style: TextStyle(color: Colors.white)),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.white24),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // login and sign up btn
                Row(
                  children: [
                    // create account btn
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          // todo : create account
                          Navigator.pushNamed(context, '/signup');
                        },
                        color: Colors.white,
                        height: 48,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: Text(
                          'Créer un compte',
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: darkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // log in btn
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          // todo: sign in
                          Navigator.pushNamed(context, '/login');
                        },
                        color: Colors.transparent,
                        height: 48,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                          side: const BorderSide(
                            width: 1,
                            color: Colors.white24,
                          ),
                        ),
                        child: Text(
                          'Se connecter',
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// 3 players image
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: SizedBox(
                width: size.width,
                child: const Image(
                  image: AssetImage('assets/3playersImage.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
