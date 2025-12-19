import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../utils/constants/app_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    // todo: create form key
    // todo: create controller for otp text field

    ///
    return Scaffold(
      appBar: AppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // headline
            Text(
              'Entrez les 4 chiffres  📩',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            // body text
            Text(
              'Veuillez entrez le code envoyé par sms.',
              style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
            ),
            const SizedBox(height: 32),

            /// form
            Form(
              child: Column(
                children: [
                  /// otp text field
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 40,
                      height: 48,
                      textStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: bodyText,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 1, color: strokeColor),
                      ),
                    ),
                    focusNode: FocusNode(),
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: blueLinguere,
                        ),
                      ],
                    ),
                    focusedPinTheme: PinTheme(
                      width: 40,
                      height: 48,
                      textStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: blueLinguere,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: blueLinguere),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 40,
                      height: 48,
                      textStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: darkBlue,
                      ),
                      decoration: BoxDecoration(
                        color: lightBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: strokeColor),
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      width: 40,
                      height: 48,
                      textStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.redAccent,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// send verification code btn
                  MaterialButton(
                    onPressed: () {
                      // todo : send verification code
                    },
                    color: blueLinguere,
                    height: 48,
                    elevation: 0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Text(
                      'Envoyer le code de réinitialisation',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Go create account
                  GestureDetector(
                    onTap: () {
                      // todo: Go create account
                      Navigator.pushReplacementNamed(context, "/forgetPassword");
                      //
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Pas le bon numéro ? ',
                            style: theme.textTheme.labelLarge!.copyWith(
                              color: bodyText,
                            ),
                            children: [
                              TextSpan(
                                text: ' Changer maintenant',
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: blueLinguere,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Resend code btn
                  TextButton(
                    onPressed: () {
                      // todo: resend the code
                    },
                    child: Text(
                      'Renvoyer le code',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: blueLinguere,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
