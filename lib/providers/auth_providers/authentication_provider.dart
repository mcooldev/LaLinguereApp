import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';

import '../../main.dart';
import '../../services/firebase_services/auth_service.dart';

abstract class AuthenticationProvider with ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _hasThreeMonTh = false;

  bool get hasThreeMonth => _hasThreeMonTh;

  /// Sign with google

  Future<void> signWithGoogle(BuildContext context) async {
    try {
      //
      final auth = AuthService.instance;
      await auth.signInWithGoogle().then((_) {
        //
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅🥳 • Connexion réussie",
              style: GoogleFonts.manrope(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: blueLinguere,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.2,
              vertical: 20,
            ),
            shape: const StadiumBorder(),
          ),
        );
        navKey.currentState?.pushNamedAndRemoveUntil("/home", (route) => false);
        //
      });
    } catch (e) {
      log("Erreur lors de la connexion avec Google : ${e.toString()}");
    }
  }
}

/// Login provider

class LoginProvider extends AuthenticationProvider {
  final loginFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  PhoneNumber? phoneNumber;

  // final passwordController = TextEditingController();

  String maskPhoneNumber(String phoneNumber) {
    final prefix = phoneNumber.substring(0, 4);
    final suffix = phoneNumber.substring(phoneNumber.length - 2);
    return "$prefix*******$suffix";
  }

  void updatePhoneNumber(PhoneNumber? newNumber) {
    phoneNumber = newNumber;
    notifyListeners();
  }

  void updateOtpCode(String newOtpCode) {
    otpController.text = newOtpCode;
    notifyListeners();
  }

  String _userVerificationId = "";

  String get userVerificationId => _userVerificationId;

  void setVerificationId(String id) {
    _userVerificationId = id;
    notifyListeners();
  }

  final auth = AuthService.instance.auth;

  Future<void> sendOtp(String userPhoneNumber) async {
    if (loginFormKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();
      //
      try {
        await auth.verifyPhoneNumber(
          phoneNumber: userPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            _isLoading = false;
            notifyListeners();
            //
            if (e.code == 'invalid-phone-number') {
              log("Le numéro fourni n'est pas valide.");
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            _userVerificationId = verificationId;
            _isLoading = false;
            notifyListeners();
            //
            navKey.currentState?.pushNamed(
              "/otpScreen",
              arguments: {
                "verificationId": verificationId,
                "phoneNumber": userPhoneNumber,
              },
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _userVerificationId = verificationId;
            _isLoading = false;
            notifyListeners();
          },
        );
      } catch (e) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (otpFormKey.currentState!.validate()) {
      //
      if (otpController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "📩 Entrer le code envoyé par sms",
              style: GoogleFonts.manrope(color: Colors.white),
            ),
            backgroundColor: redLaLinguere,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90.0),
            ),
          ),
        );
      }
      //
      if (otpController.text.trim().length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "⚠️#️⃣ Le code doit contenir 6 chiffres",
              style: GoogleFonts.manrope(color: Colors.white),
            ),
            backgroundColor: redLaLinguere,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90.0),
            ),
          ),
        );
      }
      _isLoading = true;
      notifyListeners();
      //
      try {
        //
        final credential = PhoneAuthProvider.credential(
          verificationId: userVerificationId,
          smsCode: otpController.text.trim(),
        );
        //
        await auth
            .signInWithCredential(credential)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw FirebaseAuthException(
                  code: 'timeout',
                  message: 'La connexion a pris trop de temps',
                );
              },
            );
        //
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅🥳 • Connexion réussie",
              style: GoogleFonts.manrope(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: blueLinguere,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.2,
              vertical: 20,
            ),
            shape: const StadiumBorder(),
          ),
        );
        //
        navKey.currentState?.pushNamedAndRemoveUntil("/home", (route) => false);
      } on FirebaseAuthException catch (e) {
        String errorMessage = "";
        firebaseErrorMessage(e, errorMessage);

        //
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: GoogleFonts.manrope(color: Colors.white),
            ),
            backgroundColor: redLaLinguere,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90.0),
            ),
          ),
        );

        //
      } catch (e) {
        log(e.toString());
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  String firebaseErrorMessage(FirebaseAuthException e, String errorMessage) {
    switch (e.code) {
      case 'invalid-verification-code':
        return errorMessage = '❌ Code OTP invalide';

      case 'session-expired':
        return errorMessage = '⏰ Session expirée. Renvoyez le code.';

      case 'channel-error':
        return errorMessage =
            '🔌 Erreur de connexion. Vérifiez votre Internet.';

      case 'timeout':
        return errorMessage = '⏰ Timeout. Réessayez.';

      case 'invalid-phone-number':
        return errorMessage = '📱 Numéro de téléphone invalide';

      case 'quota-exceeded':
        return errorMessage = '⚠️ Quota dépassé. Réessayez plus tard.';
      default:
        return errorMessage = 'Erreur: ${e.message ?? e.code}';
    }
  }

  ///
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}

/// Register provider

class RegisterProvider extends AuthenticationProvider {
  final registerFormKey = GlobalKey<FormState>();
}
