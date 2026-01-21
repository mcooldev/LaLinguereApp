import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/foundation_provider.dart';
import '../../utils/constants/app_colors.dart';

class ErrorPayment extends StatefulWidget {
  const ErrorPayment({super.key, required this.isDonation});

  final bool isDonation;

  @override
  State<ErrorPayment> createState() => _ErrorPaymentState();
}

class _ErrorPaymentState extends State<ErrorPayment> {
  @override
  Widget build(BuildContext context) {
    ///
    final foundationProvider = Provider.of<FoundationProvider>(context);

    ///
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            SizedBox(
              width: 80,
              height: 80,
              child: SvgPicture.asset("assets/error-icon.svg"),
            ),
            const SizedBox(height: 32),

            // title
            Text(
              "Oops !  ⚠️",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            // description
            Text(
              widget.isDonation
                  ? "Votre don a échoué."
                  : "Votre souscription a échoué.",
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

            if (widget.isDonation)
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
                  'Réessayer la souscription',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: Colors.white),
                ),
              )
            else
              // btn membership page
              MaterialButton(
                onPressed: () {
                  foundationProvider.setTabIndex(1);
                  navKey.currentState?.pushNamed("/foundation");
                },
                color: blueLinguere,
                height: 48,
                elevation: 0,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Text(
                  'Réessayer la souscription',
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
