import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:webview_windows/webview_windows.dart';

import '../../app_info/app_info.dart';
import '../../data/app_images.dart';
import '../../theme/app_color.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LoadDesktop extends StatefulWidget {
  final String loadUrl;

  const LoadDesktop({super.key, required this.loadUrl});

  @override
  State<LoadDesktop> createState() => _ExampleBrowser();
}

class _ExampleBrowser extends State<LoadDesktop> {
  final _controller = WebviewController();
  final _textController = TextEditingController();
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      await _controller.initialize();
      _subscriptions.add(_controller.url.listen((url) {
        _textController.text = url;
      }));

      _subscriptions
          .add(_controller.containsFullScreenElementChanged.listen((flag) {
        debugPrint('Contains fullscreen element: $flag');
      }));

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl(widget.loadUrl);

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Code: ${e.code}'),
                Text('Message: ${e.message}'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: !_controller.value.isInitialized
              ? Column(children: [
                  const Spacer(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 2.5,
                      child: Image.asset(AppImages.splashLogo)),
                  const Spacer(),
                  Text(AppInfo.appName,
                      style: const TextStyle(color: AppColor.kGreyColor)),
                  Text('Version:${AppInfo.appVersion}',
                      style: const TextStyle(color: AppColor.kGreyColor))
                ])
              : Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Stack(children: [
                        Webview(
                          _controller,
                          permissionRequested: _onPermissionRequested,
                        ),
                        Positioned(
                            top: 8,
                            child: IconButton(
                                onPressed: () {
                                  _controller.goBack();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                )))
                      ])))),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }

  @override
  void dispose() {
    for (var s in _subscriptions) {
      s.cancel();
    }
    _controller.dispose();
    super.dispose();
  }
}