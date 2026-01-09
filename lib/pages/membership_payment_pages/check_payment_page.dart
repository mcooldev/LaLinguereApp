import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/services/membership_payment_service/membership_payment_service.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';

class CheckPaymentPage extends StatefulWidget {
  const CheckPaymentPage({super.key, required this.isDonation});

  final bool isDonation;

  @override
  State<CheckPaymentPage> createState() => _CheckPaymentPageState();
}

class _CheckPaymentPageState extends State<CheckPaymentPage> {
  ///
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? linkSubscription;
  bool isChecking = false;

  ///

  @override
  void initState() {
    super.initState();
    linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (!mounted) return;
      handleRedirection(context, uri);
    });
  }

  void handleRedirection(BuildContext context, Uri uri) {
    if (uri.scheme == "lalinguere" && uri.host == "success") {
      if (!context.mounted) return;
      setState(() {
        isChecking = true;
      });
      MembershipPaymentService.instance.checkPayment(
        context: context,
        isDonation: widget.isDonation,
      );
      setState(() {
        isChecking = false;
      });
    }
  }

  @override
  void dispose() {
    linkSubscription?.cancel();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator.adaptive(backgroundColor: bodyText),
          const SizedBox(height: 24),
          Text(
            isChecking ? "Vérification en cours..." : "Paiement en cours...",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            "Dès que vous validez sur votre application de paiement, nous recevrons la confirmation ici.",
            textAlign: TextAlign.center,
            softWrap: true,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              if (!isChecking) {
                MembershipPaymentService.instance.checkPayment(
                  context: context,
                  isDonation: widget.isDonation,
                );
              }
            },
            child: Text(
              "Vérifier manuellement",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: blueLinguere,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
