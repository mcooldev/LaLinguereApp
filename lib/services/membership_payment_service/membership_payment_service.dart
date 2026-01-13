import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/main.dart';
import 'package:la_linguere/pages/membership_payment_pages/card_payment_view.dart';
import 'package:la_linguere/pages/membership_payment_pages/check_payment_page.dart';
import 'package:la_linguere/pages/membership_payment_pages/error_payment.dart';
import 'package:la_linguere/pages/membership_payment_pages/success_payment.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MembershipPaymentService {
  static final MembershipPaymentService instance = MembershipPaymentService._();
  late final Dio _dio;

  MembershipPaymentService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://apigatewaypayment.diotali.com/",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: false),
    );
  }

  final tokenUrlPath = "application/session/token";
  final paymentUrlPath = "application/payment";
  final sessionUrlPath = "application/command-by-remoteTrxId";

  final uuid = const Uuid();

  String generatedRequestId() {
    return uuid.v4();
  }

  ///
  Future<void> getTokenPayment({required bool isDonation}) async {
    try {
      final response = await _dio.post(
        tokenUrlPath,
        data: {
          "grant_type": "password",
          "username": "EVENT",
          "password": "EVENT@@@!!!2025",
        },
      );
      //
      if (response.statusCode == 200) {
        final status = response.data["status"] as String;
        if (status == "SUCCESS") {
          final data = response.data["data"];
          final token = data["access_token"];
          //
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (isDonation) {
            await prefs.setString("token_payment_donation", token);
          } else {
            await prefs.setString("token_payment", token);
          }
        }
        return;
      }
      return;
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  Future<void> makePayment({
    required BuildContext context,
    required String phoneNumber,
    required String amount,
    required String paymentMethod,
    required int index,
    required bool isDonation,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //
      final tokenKey = isDonation ? "token_payment_donation" : "token_payment";
      String? token = prefs.getString(tokenKey);
      if (token == null) {
        await getTokenPayment(isDonation: isDonation);
        token = prefs.getString(tokenKey);
      }
      //
      final requestId = generatedRequestId();
      await prefs.setString(
        isDonation ? "request_id_donation" : "request_id",
        requestId,
      );
      //
      final response = await _dio.post(
        paymentUrlPath,
        data: {
          "amount": int.parse(amount),
          "codeService": "TICKET",
          "currencyCode": "XOF",
          "errorUrl": "https://lalinguere.net/error",
          "partnerCode": paymentMethod,
          "phoneNumber": phoneNumber,
          "requestId": requestId,
          "successUrl": "https://lalinguere.net/success",
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      //
      if (response.statusCode == 200 && response.data["status"] == "SUCCESS") {
        //
        final data = response.data["data"];
        //
        final paymentUrl = data["launchUrl"];
        //
        if (paymentUrl != null) {
          if (index == 0 || index == 1) {
            bool launched = await launchUrl(
              Uri.parse(paymentUrl),
              mode: LaunchMode.externalApplication,
            );
            if (launched) {
              navKey.currentState?.pop();
              navKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      CheckPaymentPage(isDonation: isDonation),
                ),
                (route) => false,
              );
            }
          } else if (index == 2) {
            navKey.currentState?.pop();
            navKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => CardPaymentView(webUrl: paymentUrl),
              ),
            );
          } else {
            if (!context.mounted) return;
            navKey.currentState?.pop();
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
          }
        }
      }
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      navKey.currentState?.pop();
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
    }
  }

  Future<void> checkPayment({
    required BuildContext context,
    required bool isDonation,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //
      final token = prefs.getString(isDonation ? "token_payment_donation" : "token_payment");
      final requestId = prefs.getString(
        isDonation ? "request_id_donation" : "request_id",
      );
      //
      if (token == null || requestId == null) {
        log("Erreur: Identifiants de transaction introuvables.");
        return;
      }  
      //
      final response = await _dio.get(
        sessionUrlPath,
        queryParameters: {"remoteTrxId": requestId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data["status"] == "SUCCESS") {
        //
        final data = response.data["data"];
        final paymentStatus = data["status"] as String?;
        final remoteTrxId = data["remoteTrxId"] as String?;
        //
        if (paymentStatus == "PENDING" || paymentStatus == null) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: redLaLinguere,
              behavior: SnackBarBehavior.floating,
              shape: const StadiumBorder(),
              duration: const Duration(seconds: 3),
              content: Text(
                "⚠️ • Paiement en attente de confirmation",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
            ),
          );
        } else if (paymentStatus == "SUCCESS" && remoteTrxId == requestId) {
          await prefs.remove(isDonation ? "request_id_donation" : "request_id");
          await prefs.remove(
            isDonation ? "token_payment_donation" : "token_payment",
          );
          //
          navKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => SuccessPayment(isDonation: isDonation),
            ),
            (route) => false,
          );
        } else {
          await prefs.remove(isDonation ? "request_id_donation" : "request_id");
          await prefs.remove(
            isDonation ? "token_payment_donation" : "token_payment",
          );
          //
          navKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ErrorPayment(isDonation: isDonation),
            ),
            (route) => false,
          );
        }
      } else {
        await prefs.remove(isDonation ? "request_id_donation" : "request_id");
        await prefs.remove(
          isDonation ? "token_payment_donation" : "token_payment",
        );
        //
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: redLaLinguere,
            behavior: SnackBarBehavior.floating,
            shape: const StadiumBorder(),
            duration: const Duration(seconds: 3),
            content: Text(
              "⚠️ • Impossible de vérifier le paiement.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redLaLinguere,
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          duration: const Duration(seconds: 3),
          content: Text(
            "⚠️ • Impossible de vérifier le paiement. Veuillez contacter le support",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  ///
}
