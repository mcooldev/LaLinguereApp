import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../utils/constants/app_colors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final number = PhoneNumber(isoCode: 'SN');

    // todo: create form key

    ///
    return Scaffold(
      /// App bar
      appBar: AppBar(),

      ///
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // headline
            Text(
              'Mot de passe oublié ?  🔐',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            // body text
            Text(
              'Veuillez entrer votre numéro de téléphone pour recevoir le code de réinitialisation.',
              style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
            ),
            const SizedBox(height: 32),
            /// form
            Form(
              child: Column(
                children: [
                  /// phone number text field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(width: 1, color: strokeColor),
                    ),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        // todo
                      },
                      onInputValidated: (value) {
                        // todo
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        setSelectorButtonAsPrefixIcon: false,
                        leadingPadding: 10,
                        trailingSpace: false,
                      ),
                      initialValue: number,
                      textStyle: theme.textTheme.bodyMedium,
                      selectorTextStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: bodyText,
                      ),
                      spaceBetweenSelectorAndTextField: 8,
                      inputDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: '77 123 45 67',
                        hintStyle: theme.textTheme.bodyMedium!.copyWith(
                          color: bodyText.withValues(alpha: 0.4),
                        ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
