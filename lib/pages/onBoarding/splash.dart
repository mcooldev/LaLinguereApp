import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  ///
  Future<void> checkIfFirstTime(BuildContext context) async {
    //
    Future.delayed(const Duration(seconds: 4), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/onBoarding');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //
    checkIfFirstTime(context);
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final mqHeight = MediaQuery.sizeOf(context).height;
    final mqWidth = MediaQuery.sizeOf(context).width;

    ///
    return Scaffold(
      //
      extendBodyBehindAppBar: true,

      // body content
      body: Container(
        height: mqHeight,
        width: mqWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgWithPattern.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo image
            SizedBox(
              height: 120,
              child: Image.asset('assets/ll_splash_icon_transparent.png'),
            ),
            const SizedBox(height: 6),
            // logo name
            Text(
              'Chargement en cours ...',
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
