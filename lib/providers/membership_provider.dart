import 'package:flutter/material.dart';
import 'package:la_linguere/models/user_model.dart';
import 'package:la_linguere/providers/auth_providers/authentication_provider.dart';

import '../services/membership_payment_service/membership_payment_service.dart';
import '../utils/constants/app_colors.dart';

class MembershipProvider with ChangeNotifier {
  final List<Map<String, String>> _paymentList = [
    {"title": "Wave", "image": "assets/wave-logo.png"},
    {"title": "Orange Money", "image": "assets/om-logo.png"},
    {"title": "Carte bancaire", "image": "assets/card-logo.png"},
  ];

  List<Map<String, String>> get paymentList => _paymentList;

  final List<String> _partnerCodes = ["wave", "orangemoney", "orabank"];

  List<String> get partnerCodes => _partnerCodes;

  LoginProvider logProvider = LoginProvider();

  int _paymentIndex = -1;

  int get paymentIndex => _paymentIndex;

  void setPaymentIndex(int index) {
    _paymentIndex = index;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final donationFormKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  ///

  int _loadingPercentage = 0;

  int get loadingPercentage => _loadingPercentage;

  void setLoadingPercentage(int percentage) {
    _loadingPercentage = percentage;
    notifyListeners();
  }

  ///

  Future<void> proceedToPayment({
    required BuildContext context,
    required String? phoneNumber,
    required String amount,
    required bool isDonation,
    required MembershipType? newMembershipType,
  }) async {
    if (isLoading) return;
    //
    if (_paymentIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redLaLinguere,
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          content: Text(
            "🤑 • choisissez un moyen de paiement",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      );
      return;
    }
    //
    if (logProvider.signedAsGuest && logProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redLaLinguere,
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          duration: const Duration(seconds: 3),
          content: Text(
            "⚠️ • Connectez-vous pour effectuer ce paiement",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      );
      return;
    }
    //
    _isLoading = true;
    notifyListeners();
    //
    try {
      await MembershipPaymentService.instance.makePayment(
        context: context,
        phoneNumber: phoneNumber.toString(),
        amount: amount,
        paymentMethod: _partnerCodes[_paymentIndex],
        index: _paymentIndex,
        isDonation: isDonation,
        newMembershipType: newMembershipType,
      );
      //
      if (isDonation) {
        amountController.clear();
        _paymentIndex == -1;
        notifyListeners();
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redLaLinguere,
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          duration: const Duration(seconds: 3),
          content: Text(
            "⚠️ • Erreur lors du paiement",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
