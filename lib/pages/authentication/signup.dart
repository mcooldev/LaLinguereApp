import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:la_linguere/providers/auth_providers/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';

import '../../main.dart';
import '../../utils/constants/app_colors.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  ///
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Recaptcha.fetchClient(config.recaptchaSiteKey);
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final number = PhoneNumber(isoCode: 'SN');

    ///
    return Scaffold(
      /// App bar
      appBar: AppBar(),

      ///
      body: Consumer<RegisterProvider>(
        builder: (_, prov, _) {
          return SingleChildScrollView(
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
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: bodyText,
                  ),
                ),
                const SizedBox(height: 32),

                // form
                Form(
                  key: prov.registerFormKey,
                  child: Column(
                    children: [
                      /// full name text field
                      TextFormField(
                        controller: prov.fullNameController,
                        //
                        onTapOutside: (pointer) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        //
                        validator: (val) {
                          if (val == null || val.isEmpty || val.length < 3) {
                            return "Veuillez entrer votre nom complet";
                          }
                          return null;
                        },
                        //
                        textCapitalization: TextCapitalization.words,
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
                            borderSide: BorderSide(
                              width: 1,
                              color: strokeColor,
                            ),
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
                      const SizedBox(height: 12),

                      /// phone number text field
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            border: Border.all(
                              width: 1,
                              color: strokeColor,
                            ),
                          ),
                          child: InternationalPhoneNumberInput(
                            textFieldController:
                                prov.registerPhoneNumberController,
                            onInputChanged: (PhoneNumber number) {
                              prov.updateRegisterPhoneNumber(number);
                            },
                            onInputValidated: (value) {},
                            keyboardType:
                                const TextInputType.numberWithOptions(
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
                            selectorTextStyle: theme.textTheme.bodyMedium!
                                .copyWith(color: bodyText),
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

                      /// verification otp btn
                      MaterialButton(
                        onPressed: prov.isLoading ? null : () async {
                          final phoneToSend =
                              prov.registerPhoneNumber?.phoneNumber ?? "";
                          //
                          if (phoneToSend.isNotEmpty) {
                            try {
                              //
                              await prov.sendOtp(
                                userPhoneNumber: phoneToSend,
                                formKey: prov.registerFormKey,
                                otpAccessType: "register",
                                userFullName: prov.fullNameController.text,
                              );
                            } catch (e) {
                              log("Error while sending otp: $e");
                            }
                          }
                        },
                        color: blueLinguere,
                        height: 48,
                        elevation: 0,
                        minWidth: prov.isLoading ? 48 : double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: prov.isLoading
                            ? const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Vérifier mon numéro',
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
                    prov.fullNameController.clear();
                    prov.registerPhoneNumberController.clear();
                    //
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
                    Expanded(
                      child: Divider(thickness: 1, color: strokeColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Ou', style: TextStyle(color: bodyText)),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: strokeColor),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                /// google sign in btn
                MaterialButton(
                  onPressed: () async {
                    //
                    prov.signWithGoogle(context);
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
          );
        },
      ),
    );
  }
}
