import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../../utils/constants/app_colors.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({super.key, required this.isDonation});

  final bool isDonation;

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            SizedBox(
              width: 80,
              height: 80,
              child: SvgPicture.asset(
                widget.isDonation
                    ? "assets/donation-success-icon.svg"
                    : "assets/success-icon.svg",
              ),
            ),
            const SizedBox(height: 32),

            // title
            Text(
              widget.isDonation ? "Merci à vous !  🙏🏽" : "Bravo !  🥳",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            // description
            Text(
              widget.isDonation
                  ? "Merci beaucoup pour votre don,\nvotre soutien nous est très précieux."
                  : "Votre souscription en tant\nqu’abonné a réussi.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: bodyText),
            ),
            const SizedBox(height: 32),

            // btn home
            MaterialButton(
              onPressed: () {
                navKey.currentState?.pushNamed("/home");
              },
              color: Colors.white,
              height: 48,
              elevation: 0,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
                side: BorderSide(width: 1, color: lightStrokeColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_rounded, color: blueLinguere),
                  const SizedBox(width: 8),
                  Text(
                    "Retourner à l'accueil",
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.copyWith(color: blueLinguere),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // btn profile
            MaterialButton(
              onPressed: () {
                navKey.currentState?.pushNamed("/profile");
              },
              color: blueLinguere,
              height: 48,
              elevation: 0,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
              child: Text(
                'Voir mon compte',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
