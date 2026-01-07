import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:la_linguere/services/firebase_services/firestore_service.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../services/firebase_services/auth_service.dart';

abstract class AuthenticationProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _signedAsGuest = false;

  bool get signedAsGuest => _signedAsGuest;

  void setSignedAsGuest(bool value) {
    _signedAsGuest = value;
    notifyListeners();
  }

  String _otpAccessType = "";

  String get otpAccessType => _otpAccessType;

  void setOtpAccessType(String value) {
    _otpAccessType = value;
    notifyListeners();
  }

  String _userVerificationId = "";

  String get userVerificationId => _userVerificationId;

  final auth = AuthService.instance.auth;

  void setVerificationId(String id) {
    _userVerificationId = id;
    notifyListeners();
  }

  final otpController = TextEditingController();

  void updateOtpCode(String newOtpCode) {
    otpController.text = newOtpCode;
    notifyListeners();
  }

  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final firestoreService = FirestoreService.instance;

  Future<bool> checkIfUserExists(String uid) async {
    try {
      final snapshot = await firestoreService.firestore
          .collection("users")
          .doc(uid)
          .get();
      return snapshot.exists;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String verifId,
    required String otpAccessType,
    required String userName,
    required String userPhoneNumber,
  }) async {
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
        return;
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
        return;
      }
      _isLoading = true;
      notifyListeners();
      //
      try {
        //
        final credential = PhoneAuthProvider.credential(
          verificationId: verifId,
          smsCode: otpController.text.trim(),
        );
        //
        if (otpAccessType.contains("login")) {
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
          final user = auth.currentUser;
          if (user == null) return;
          final userId = user.uid;
          bool exist = await checkIfUserExists(userId);
          //
          if (!exist) {
            if (!context.mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.all(16),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "⚠️",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge!.copyWith(color: redLaLinguere),
                    ),
                    //
                    const SizedBox(height: 12),
                    Text(
                      "Vous n'avez pas encore de compte sur La Linguere !",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    //
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                actions: [
                  // continue as guest btn
                  MaterialButton(
                    onPressed: () async {
                      navKey.currentState?.pop();
                      await AuthService.instance.signOut();
                      setSignedAsGuest(true);
                      otpController.clear();
                    },
                    color: Colors.transparent,
                    height: 48,
                    elevation: 0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90),
                      side: BorderSide(color: strokeColor, width: 1),
                    ),
                    child: Text(
                      "Continuer en tant qu'Invité",
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.copyWith(color: blueLinguere),
                    ),
                  ),
                  //
                  const SizedBox(height: 12),
                  // create account btn
                  MaterialButton(
                    onPressed: () async {
                      //
                      navKey.currentState?.pop();
                      await AuthService.instance.signOut();
                      otpController.clear();
                      navKey.currentState?.pushNamed("/signup");
                    },
                    color: blueLinguere,
                    height: 48,
                    elevation: 0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Text(
                      "S'inscrire maintenant",
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          otpController.clear();
        }

        ///
        if (otpAccessType.contains("register")) {
          final userCredentials = await auth
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
          final userId = userCredentials.user?.uid;
          final userEmail = "";
          final finalUser = UserModel(
            id: userId,
            fullName: userName,
            email: userEmail,
            phoneNumber: userPhoneNumber,
            isMember: false,
            lastLogin: Timestamp.now(),
            createdAt: Timestamp.now(),
            membershipType: MembershipType.notSubscribed,
          );
          await firestoreService.addUserData(finalUser);
          //
          otpController.clear();
          //
          navKey.currentState?.pushNamedAndRemoveUntil(
            "/authGate",
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = firebaseErrorMessage(e);

        //
        if (!context.mounted) return;
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

  String firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return '❌ Code OTP invalide';

      case 'session-expired':
        return '⏰ Session expirée. Renvoyez le code.';

      case 'channel-error':
        return '🔌 Erreur de connexion. Vérifiez votre Internet.';

      case 'timeout':
        return '⏰ Timeout. Réessayez.';

      case 'invalid-phone-number':
        return '📱 Numéro de téléphone invalide';

      case 'quota-exceeded':
        return '⚠️ Quota dépassé. Réessayez plus tard.';
      default:
        return 'Erreur: ${e.message ?? e.code}';
    }
  }

  /// Send otp

  Future<void> sendOtp({
    required String userPhoneNumber,
    required GlobalKey<FormState> formKey,
    required String otpAccessType,
    required String? userFullName,
  }) async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }
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
              "fullName": otpAccessType == "register" ? userFullName : "",
              "otpAccessType": otpAccessType,
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

  /// Sign with google

  Future<void> signWithGoogle(BuildContext context) async {
    try {
      //
      final auth = AuthService.instance;
      final userCredential = await auth.signInWithGoogle();
      if (userCredential != null) {
        final userId = userCredential.user?.uid;
        final userEmail = userCredential.user?.email;
        final userName = userCredential.user?.displayName;
        final phone = userCredential.user?.phoneNumber;
        //
        final finalUser = UserModel(
          id: userId,
          fullName: userName,
          email: userEmail,
          phoneNumber: phone ?? "",
          isMember: false,
          membershipType: null,
        );
        await firestoreService.addUserData(finalUser);
        //
        navKey.currentState?.pushNamedAndRemoveUntil(
          "/authGate",
          (route) => false,
        );
        //
      }
    } catch (e) {
      log("Erreur lors de la connexion avec Google : ${e.toString()}");
    }
  }
}

/// Login provider

class LoginProvider extends AuthenticationProvider {
  final loginFormKey = GlobalKey<FormState>();

  final phoneNumberController = TextEditingController();

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

  //
  UserModel? user;

  String get userEmailOrPhoneText {
    final hasEmail = user?.email != null && user!.email!.isNotEmpty;
    final hasPhoneNumber =
        user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty;
    //
    if (hasEmail && hasPhoneNumber) {
      return "${user?.email} • ${user?.phoneNumber}";
    }
    if (hasEmail && !hasPhoneNumber) {
      return user!.email!;
    }
    if (!hasEmail && hasPhoneNumber) {
      return user!.phoneNumber!;
    }
    return "77 123 45 67 • exemple@invité.com";
  }

  Future<void> getUserData() async {
    try {
      final userCollections = firestoreService.firestore
          .collection('users')
          .doc(auth.currentUser?.uid);
      //
      final snapshot = await userCollections.get();
      //
      if (snapshot.exists && snapshot.data() != null) {
        final userData = snapshot.data() as Map<String, dynamic>;
        user = UserModel.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateUserDataMembership(String newMembership) async {
    // todo: update user membership in firestore
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
  final fullNameController = TextEditingController();

  void setFullName(String? value) {
    fullNameController.text = value ?? "";
    notifyListeners();
  }

  final registerPhoneNumberController = TextEditingController();
  PhoneNumber? registerPhoneNumber;

  void updateRegisterPhoneNumber(PhoneNumber? newNumber) {
    registerPhoneNumber = newNumber;
    notifyListeners();
  }

  Future<void> registerUser(BuildContext context) async {
    if (registerFormKey.currentState!.validate()) {
      //
    }
  }

  ///
  @override
  void dispose() {
    // TODO: implement dispose
    fullNameController.dispose();
    registerPhoneNumberController.dispose();
    super.dispose();
  }
}
