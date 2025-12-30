import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final objectController = TextEditingController();
  final messageController = TextEditingController();
  final supportFormKey = GlobalKey<FormState>();

  Future<void> onSubmitForm() async {
    if (supportFormKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final object = objectController.text.trim();
      final message = messageController.text.trim();
      //
      final queries = {
        'subject': object,
        'body': "Email de l'utilisateur: $email\n\n$message",
      };
      //
      final emailToSubmit = Uri(
        scheme: 'mailto',
        path: 'm.coulibaly@diotali.com',
        query: queries.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&'),
      );
      //
      if (!await launchUrl(
        emailToSubmit,
        mode: LaunchMode.externalApplication,
      )) {
        log("Error while submitting form");
      }
      //
      emailController.clear();
      objectController.clear();
      messageController.clear();
      //
      notifyListeners();
    }
  }

  /// disposer
  @override
  void dispose() {
    emailController.dispose();
    objectController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
