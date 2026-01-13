import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/main.dart';
import 'package:la_linguere/pages/membership_payment_pages/error_payment.dart';
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
    //
    _appLinks.getInitialLink().then((uri) {
      if (uri != null && !mounted) return;
      handleRedirection(context, uri);
    });
    //
    linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (!mounted) return;
      handleRedirection(context, uri);
    });
  }

  void handleRedirection(BuildContext context, Uri? uri) async {
    if (uri == null) return;
    //
    bool isSuccess =
        (uri.scheme == "lalinguere" && uri.host == "success") ||
        (uri.host == "lalinguere.net" && uri.path == "/success");
    bool isError =
        (uri.scheme == "lalinguere" && uri.host == "error") ||
        (uri.host == "lalinguere.net" && uri.path == "/error");

    //
    if (isSuccess) {
      if (!context.mounted) return;
      if (mounted) {
        setState(() => isChecking = true);
      }
      //
      try {
        await MembershipPaymentService.instance.checkPayment(
          context: context,
          isDonation: widget.isDonation,
        );
      } finally {
        if (mounted) {
          setState(() => isChecking = false);
        }
      }
    } else if (isError) {
      navKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ErrorPayment(isDonation: widget.isDonation),
        ),
        (route) => false,
      );
      //
      if (mounted) {
        setState(() => isChecking = false);
      }
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
            onPressed: () async {
              if (!isChecking) {
                await MembershipPaymentService.instance.checkPayment(
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
