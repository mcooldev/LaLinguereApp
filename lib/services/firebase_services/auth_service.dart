import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final auth = FirebaseAuth.instance;

  final GoogleSignIn gSignIn = GoogleSignIn.instance;

  final _clientId =
      "1051920178350-mej50jcd4kujl20ggohtscnpkupe0h28.apps.googleusercontent.com";
  final _serverClientId =
      "1051920178350-0ce0ad2p818bkgbul154j2okr42rib0f.apps.googleusercontent.com";

  Future<UserCredential?> signInWithGoogle() async {
    //
    await gSignIn.initialize(
      clientId: _clientId,
      serverClientId: _serverClientId,
    );
    //
    if (!gSignIn.supportsAuthenticate()) return null;
    //
    try {
      //
      final GoogleSignInAccount? gUser = await gSignIn.authenticate();
      if (gUser == null) return null;
      //
      final gAuth = await gUser.authorizationClient.authorizationForScopes([
        "email",
        "profile",
      ]);
      if (gAuth == null) return null;
      //
      final idToken = gUser.authentication.idToken;
      final accessToken = gAuth.accessToken;
      //
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      //
      return await auth.signInWithCredential(credential);
    } catch (e) {
      //
      log(e.toString());
      return null;
    }
  }

  ///
  Future<void> signOut() async {
    await auth.signOut();
    await gSignIn.signOut();
  }


}
