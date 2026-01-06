import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../main.dart';
import '../../services/firebase_services/auth_service.dart';
import '../../utils/constants/app_colors.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final number = PhoneNumber(isoCode: 'SN');

    // todo: create form key
    // todo: Set the controllers for the form

    ///
    return Scaffold(
      /// App bar
      appBar: AppBar(),

      ///
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // headline
            Text(
              'Créons votre compte  ⚽️',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            // body text
            Text(
              'Veuillez renseigner vos informations.',
              style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
            ),
            const SizedBox(height: 32),

            // form
            Form(
              child: Column(
                children: [
                  /// full name text field
                  TextFormField(
                    //
                    onTapOutside: (pointer) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    //
                    validator: (val){
                      // todo: Set the validator
                      return;
                    },
                    //
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: bodyText,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      //
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                        borderSide: BorderSide(width: 1, color: strokeColor),
                      ),
                      //
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      //
                      hintText: 'Nom complet',
                      hintStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: bodyText.withValues(alpha: 0.5),
                      ),

                      //
                      prefixIcon: Icon(
                        CupertinoIcons.person,
                        size: 22,
                        color: bodyText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),

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
                  const SizedBox(height: 12),

                  /// password text field
                  TextFormField(
                    //
                    onTapOutside: (pointer) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    //
                    validator: (val){
                      // todo: Set the validator
                      return;
                    },
                    //
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: bodyText,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      //
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                        borderSide: BorderSide(width: 1, color: strokeColor),
                      ),
                      //
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      //
                      hintText: 'Mot de passe',
                      hintStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: bodyText.withValues(alpha: 0.5),
                      ),

                      //
                      prefixIcon: Icon(
                        CupertinoIcons.lock,
                        size: 22,
                        color: bodyText,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // todo: toggle obscure text
                        },
                        icon: Icon(
                          CupertinoIcons.eye,
                          size: 22,
                          color: blueLinguere,
                        ),
                      ),
                    ),
                    //
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),

                  /// password confirmation text field
                  TextFormField(
                    //
                    onTapOutside: (pointer) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    //
                    validator: (val){
                      // todo: Set the validator
                      return;
                    },
                    //
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: bodyText,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      //
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                        borderSide: BorderSide(width: 1, color: strokeColor),
                      ),
                      //
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      //
                      hintText: 'Confirmer le mot de passe',
                      hintStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: bodyText.withValues(alpha: 0.5),
                      ),

                      //
                      prefixIcon: Icon(
                        CupertinoIcons.lock,
                        size: 22,
                        color: bodyText,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // todo: toggle obscure text
                        },
                        icon: Icon(
                          CupertinoIcons.eye,
                          size: 22,
                          color: blueLinguere,
                        ),
                      ),
                    ),
                    //
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),

                  /// sign in btn
                  MaterialButton(
                    onPressed: () {
                      // todo : call sign in method
                    },
                    color: blueLinguere,
                    height: 48,
                    elevation: 0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Text(
                      'Créer le compte maintenant',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Go sign in
            GestureDetector(
              onTap: () {
                // todo: Go sign in
                Navigator.pushReplacementNamed(context, "/login");
                //
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Déjà un compte ? ',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: bodyText,
                      ),
                      children: [
                        TextSpan(
                          text: ' Se connecter maintenant',
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
            const SizedBox(height: 32),

            /// or
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: strokeColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Ou', style: TextStyle(color: bodyText)),
                ),
                Expanded(child: Divider(thickness: 1, color: strokeColor)),
              ],
            ),
            const SizedBox(height: 32),

            /// google sign in btn
            MaterialButton(
              onPressed: () async {
                //
                final auth = AuthService.instance;
                await auth.signInWithGoogle();
                //
                navKey.currentState?.pushNamedAndRemoveUntil(
                  "/home",
                      (route) => false,
                );
                //
              },
              color: Colors.white,
              height: 48,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
                side: BorderSide(width: 1, color: strokeColor),
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
                      color: bodyText,
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
