import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/models/user_model.dart';
import 'package:la_linguere/pages/membership_payment_pages/error_payment.dart';
import 'package:la_linguere/services/membership_payment_service/membership_payment_service.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_providers/authentication_provider.dart';

class CheckPaymentPage extends StatefulWidget {
  const CheckPaymentPage({
    super.key,
    required this.isDonation,
    this.membershipType,
  });

  final bool isDonation;
  final MembershipType? membershipType;

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
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    try {
      final uri = await _appLinks.getInitialLink();
      //
      if (uri != null && mounted) {
        handleRedirection(context, uri);
      }
    } catch (e) {
      log("error get initial link : $e");
    }
    //
    linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (mounted) {
        handleRedirection(context, uri);
      }
    }, onError: (error) => log("error uri link stream : $error"));
  }

  void handleRedirection(BuildContext context, Uri? uri) async {
    if (uri == null || isChecking) return;
    log("vérification en cours");
    //
    if (uri.scheme != "https" || uri.host != "lalinguere.net") {
      log("⚠️ Pas un universal link valide pour lalinguere.net");
      return;
    }
    //
    bool isSuccess = uri.host == "lalinguere.net" && uri.path == "/success";
    bool isError = uri.host == "lalinguere.net" && uri.path == "/error";

    //
    if (isSuccess) {
      if (!context.mounted) return;
      if (mounted) {
        setState(() => isChecking = true);
      }
      log("vérification terminée avec success");
      //
      try {
        //
        final loginProvider = Provider.of<LoginProvider>(
          context,
          listen: false,
        );
        //
        await MembershipPaymentService.instance.checkPayment(
          context: context,
          isDonation: widget.isDonation,
          newMembershipType:
              widget.membershipType ?? MembershipType.notSubscribed,
          loginProvider: loginProvider,
        );
      } finally {
        if (mounted) {
          setState(() => isChecking = false);
        }
        log("vérification terminée");
      }
    } else if (isError) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ErrorPayment(isDonation: widget.isDonation),
        ),
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
    ///
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    ///
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              onPressed: isChecking
                  ? null
                  : () async {
                      await MembershipPaymentService.instance.checkPayment(
                        context: context,
                        isDonation: widget.isDonation,
                        newMembershipType:
                            widget.membershipType ??
                            MembershipType.notSubscribed,
                        loginProvider: loginProvider,
                      );
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
            const SizedBox(height: 24),

            // quit button
            TextButton(
              onPressed: isChecking
                  ? null
                  : () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove(
                        widget.isDonation
                            ? "request_id_donation"
                            : "request_id",
                      );
                      await prefs.remove(
                        widget.isDonation
                            ? "token_payment_donation"
                            : "token_payment",
                      );
                      //
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
              child: Text(
                "Annuler la transaction",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: redLaLinguere,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
