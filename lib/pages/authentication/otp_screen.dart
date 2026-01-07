import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la_linguere/providers/auth_providers/authentication_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../providers/on_boarding_provider.dart';
import '../../utils/constants/app_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  ///
  late String userVerificationId, userPhoneNumber, otpAccessType;
  late String? userFullName;
  bool _isInit = false;
  Timer? _timer;
  int _startTime = 60;
  bool canResendCode = false;

  void startTimer() {
    canResendCode = false;
    _startTime = 60;
    //
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime == 0) {
        setState(() {
          canResendCode = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _startTime--;
        });
      }
    });
  }

  ///

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    ///
    super.didChangeDependencies();

    ///
    if (!_isInit) {
      final arg = ModalRoute.of(context)?.settings.arguments as Map;
      userVerificationId = arg["verificationId"];
      userPhoneNumber = arg["phoneNumber"];
      otpAccessType = arg["otpAccessType"];
      userFullName = arg["fullName"] ?? "";

      ///
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<LoginProvider>(context, listen: false)
          ..setVerificationId(userVerificationId)
          ..setOtpAccessType(otpAccessType);
        //
        Provider.of<RegisterProvider>(
          context,
          listen: false,
        ).setFullName(userFullName);
      });

      ///
      _isInit = true;
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final obProvider = Provider.of<OnBoardingProvider>(context, listen: false);

    ///
    return Consumer2<LoginProvider, RegisterProvider>(
      builder: (_, prov, registerProv, _) {
        ///

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
                  'Entrez les 6 chiffres  📩',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),

                // body text
                Text.rich(
                  TextSpan(
                    text: 'Veuillez entrez le code envoyé par sms au .',
                    children: [
                      TextSpan(
                        text: prov.maskPhoneNumber(userPhoneNumber),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: bodyText,
                        ),
                      ),
                    ],
                  ),
                  style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
                ),

                const SizedBox(height: 32),

                /// form
                Form(
                  key: prov.otpFormKey,
                  child: Column(
                    children: [
                      /// otp text field
                      Pinput(
                        controller: prov.otpController,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onCompleted: prov.updateOtpCode,
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

                      /// verification code btn
                      MaterialButton(
                        onPressed: () async {
                          await prov
                              .verifyOtp(
                                context: context,
                                verifId: userVerificationId,
                                otpAccessType: otpAccessType,
                                userName: userFullName ?? "",
                                userPhoneNumber: userPhoneNumber,
                              )
                              .then((_) {
                                prov.otpController.clear();
                                prov.phoneNumberController.clear();
                                registerProv.registerPhoneNumberController
                                    .clear();
                                registerProv.fullNameController.clear();
                                prov.setSignedAsGuest(false);
                              });
                          if (!context.mounted) return;
                          if (prov.user != null) {
                            await obProvider.completeOnBoarding();
                          }
                          //
                        },
                        color: blueLinguere,
                        height: 48,
                        elevation: 0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: prov.isLoading
                            ? const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Se connecter maintenant',
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
                          Navigator.pushReplacementNamed(
                            context,
                            "/forgetPassword",
                          );
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
                        onPressed: canResendCode
                            ? () {
                                if (otpAccessType.contains("login")) {
                                  //
                                  prov.sendOtp(
                                    userPhoneNumber: userPhoneNumber,
                                    formKey: prov.loginFormKey,
                                    otpAccessType: "login",
                                    userFullName: userFullName,
                                  );
                                  startTimer();
                                } else {
                                  prov.sendOtp(
                                    userPhoneNumber: userPhoneNumber,
                                    formKey: registerProv.registerFormKey,
                                    otpAccessType: "register",
                                    userFullName: userFullName,
                                  );
                                  startTimer();
                                }
                              }
                            : null,
                        child: Text(
                          canResendCode
                              ? 'Renvoyer le code'
                              : '00:${_startTime.toString().padLeft(2, '0')}',
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
      },
    );
  }
}
