import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/back_press_dialog.dart';

class LoadAndroidTv extends StatefulWidget {
  const LoadAndroidTv({super.key, required this.loadUrl});

  final String loadUrl;

  @override
  State<LoadAndroidTv> createState() => _LoadAndroidTvState();
}

class _LoadAndroidTvState extends State<LoadAndroidTv> {
  final GlobalKey webViewKey = GlobalKey();
  final controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
          canPop: false,
          onPopInvoked: handleWillPop,
          child: Scaffold(
              body: WebViewWidget(
            key: webViewKey,
            controller: controller
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {},
                  onPageStarted: (String url) {
                    print('$url ------------------------j');
                  },
                  onPageFinished: (String url) {
                    print('$url ------------------------j');
                  },
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
          ))),
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
      if (await controller.canGoBack()) {
        controller.goBack();
      } else {
        CustomDialog.onBackPressed(context);
      }
      return false;
    }
    return false;
  }
}