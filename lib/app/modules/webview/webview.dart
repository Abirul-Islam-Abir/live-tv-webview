import "package:flutter/material.dart";
 import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/back_press_dialog.dart';

class LoadTv extends StatefulWidget {
  const LoadTv({super.key, required this.loadUrl});

  final String loadUrl;

  @override
  State<LoadTv> createState() => _LoadTvState();
}

class _LoadTvState extends State<LoadTv> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
          canPop: false,
          onPopInvoked: handleWillPop,
          child: Scaffold(
            body: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(widget.loadUrl)),
            ),
          )),
    );
  }

  DateTime? backButtonPressTime;

  Future<bool> handleWillPop(data) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 1);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      CustomDialog.onBackPressed(context);
      return false;
    }
    return false;
  }
}