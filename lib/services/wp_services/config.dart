import 'dart:io';

class Config {
  Config._();

  static final Config instance = Config._();

  ///
  final String baseUrl = "lalinguere.net";
  final recaptchaSiteKey = Platform.isAndroid
      ? "6LeofEssAAAAAGcWoYS929G8VyLG8WtnvctNZeIo"
      : "6Ld7a0ssAAAAAIZkauWvMyFkeZVUHVXTqRp4DziY";
}
