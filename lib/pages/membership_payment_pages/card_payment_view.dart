import 'package:flutter/material.dart';
import 'package:la_linguere/main.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../providers/membership_provider.dart';
import '../../utils/constants/app_colors.dart';

class CardPaymentView extends StatefulWidget {
  const CardPaymentView({super.key, required this.webUrl});

  final String webUrl;

  @override
  State<CardPaymentView> createState() => _CardPaymentViewState();
}

class _CardPaymentViewState extends State<CardPaymentView> {
  ///
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      final prov = Provider.of<MembershipProvider>(context, listen: false);
      //
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              prov.setLoadingPercentage(progress);
            },
            onPageStarted: (String url) {
              prov.setLoadingPercentage(0);
            },
            onPageFinished: (String url) {
              prov.setLoadingPercentage(100);
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains("success")) {
                navKey.currentState?.pushNamedAndRemoveUntil(
                  "/successPayment",
                  (route) => false,
                );
                return NavigationDecision.prevent;
              } else if (request.url.contains("error")) {
                navKey.currentState?.pushNamedAndRemoveUntil(
                  "/errorPayment",
                  (route) => false,
                );
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.webUrl));
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Paiement par carte'),
        //
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: lightStrokeColor),
              ),
            ),
          ),
        ),
      ),

      /// body view
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (await controller.canGoBack()) {
            await controller.goBack();
          } else {
            navKey.currentState?.pop();
          }
        },
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
