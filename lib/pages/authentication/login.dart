import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:la_linguere/providers/auth_providers/authentication_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final number = PhoneNumber(isoCode: 'SN');

    ///
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Consumer<LoginProvider>(
        builder: (_, loginProv, _) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Scaffold(
              // app bar
              appBar: AppBar(),

              // body content
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // headline
                    Text(
                      'Content de vous revoir  👋🏾',
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),

                    // body text
                    Text(
                      'Veuillez vous connecter pour continuer.',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: bodyText,
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// form
                    Form(
                      key: loginProv.loginFormKey,
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
                              textFieldController:
                                  loginProv.phoneNumberController,
                              onInputChanged: (PhoneNumber number) async {
                                loginProv.updatePhoneNumber(number);
                              },
                              onInputValidated: (value) {},
                              countrySelectorScrollControlled: true,
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

                          /// password text field
                          //passwordTextFormField(theme),
                          const SizedBox(height: 16),

                          /// forget password
                          //Row(
                          //  mainAxisAlignment: MainAxisAlignment.end,
                          //  children: [
                          //    TextButton(
                          //      onPressed: () {
                          //        // todo: go to forget password page
                          //        Navigator.pushNamed(context, '/forgetPassword');
                          //      },
                          //      child: Text(
                          //        'Mot de passe oublé',
                          //        style: theme.textTheme.labelLarge!.copyWith(
                          //          color: blueLinguere,
                          //        ),
                          //      ),
                          //    ),
                          //  ],
                          //),
                          //const SizedBox(height: 16),

                          /// sign in btn
                          MaterialButton(
                            onPressed: () async {
                              final phoneToSend =
                                  loginProv.phoneNumber?.phoneNumber ?? "";
                              //
                              if (phoneToSend.isNotEmpty) {
                                await loginProv.sendOtp(phoneToSend);
                              }
                            },
                            color: blueLinguere,
                            height: 48,
                            elevation: 0,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: loginProv.isLoading
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

                    /// Go create account
                    GestureDetector(
                      onTap: () {
                        //
                        Navigator.pushReplacementNamed(context, "/signup");
                        //
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'Pas encore de compte ? ',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: bodyText,
                              ),
                              children: [
                                TextSpan(
                                  text: ' Créer maintenant',
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
                        await loginProv.signWithGoogle(context);
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
            ),
          );
        },
      ),
    );
  }

  TextFormField passwordTextFormField(ThemeData theme) {
    return TextFormField(
      //
      onTapOutside: (pointer) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      //
      style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
        //
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: BorderSide(width: 1, color: strokeColor),
        ),
        //
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        //
        hintText: '••••••••',
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
          color: bodyText.withValues(alpha: 0.5),
        ),

        //
        prefixIcon: Icon(CupertinoIcons.lock, size: 22, color: bodyText),
        suffixIcon: IconButton(
          onPressed: () {
            // todo: toggle obscure text
          },
          icon: Icon(CupertinoIcons.eye, size: 22, color: blueLinguere),
        ),
      ),
      //
      obscureText: true,
    );
  }
}
