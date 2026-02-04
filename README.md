# 🏟️ La Linguere – Application Mobile Officielle

**La Linguere** est une application mobile développée avec **Flutter** pour le club sportif **La Linguere du Sénégal**.  
Elle vise à offrir aux supporters, joueurs et staff un accès moderne et centralisé aux informations, actualités et services du club.

---

## 📱 Fonctionnalités principales

- 🔐 Authentification sécurisée (Téléphone(OTP) / Google)
- 📰 Actualités et contenus du club
- 🔔 Notifications push en temps réel
- 📅 Informations sportives et événements
- 🌍 Liens externes et contenus web intégrés
- 🧾 Gestion d’état et persistance locale
- 🎨 Interface moderne et responsive

*(Certaines fonctionnalités peuvent évoluer selon les besoins du club)*

---

## 🚀 Technologies utilisées

- **Flutter** (Dart)
- **Firebase**
    - Authentication
    - Firestore
    - Cloud Messaging
    - App Check
- **Provider** pour la gestion d’état
- **Dio** pour les appels API
- **Firebase Cloud Messaging** pour les notifications push

---

## 📦 Packages Flutter utilisés

```yaml
provider: ^6.1.5+1
flutter_secure_storage: ^10.0.0
google_fonts: ^7.1.0
shared_preferences: ^2.5.4
intl_phone_number_input: ^0.7.5
pinput: ^6.0.1
flutter_svg: ^2.2.3
intl: ^0.20.2
uuid: ^4.5.2
url_launcher: ^6.3.2
hugeicons: ^1.1.5
infinite_carousel: ^1.1.1
grouped_list: ^6.0.0
dio: ^5.9.0
cached_network_image: ^3.4.1
firebase_messaging: ^16.1.1
firebase_core: ^4.4.0
flutter_local_notifications: ^19.5.0
flutter_launcher_icons: ^0.14.4
firebase_auth: ^6.1.4
google_sign_in: ^7.2.0
cloud_firestore: ^6.1.2
app_links: ^7.0.0
custom_input_formatter: ^2.0.1
webview_flutter: ^4.13.1
firebase_app_check: ^0.4.1+4
recaptcha_enterprise_flutter: ^18.8.2
app_badge_plus: ^1.2.6
````

## 🛠️ Installation & Configuration
### Prérequis

Flutter SDK (version stable)
Dart
Android Studio / VS Code
Compte Firebase configuré

```bash
https://gitlab.diotali.com/Mouhamadou/la-linguere.git 
````

## 🔐 Configuration Firebase

### Créer un projet Firebase
Ajouter les applications Android et/ou iOS
### Télécharger :
google-services.json (Android)
GoogleService-Info.plist (iOS)
### Activer :
Authentication
Firestore
Cloud Messaging
App Check

## 📄 Licence
Ce projet est développé pour le club La Linguere du Sénégal.
Toute utilisation commerciale ou redistribution doit être autorisée.

## 👨‍💻 Développeur
Développé avec ❤️ en Flutter
Par [Mouhamadou Coulibaly]