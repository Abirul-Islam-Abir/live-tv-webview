import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_tv_webview/app/modules/blank_screen/blank_screen.dart';

import '../../app_info/app_info.dart';
import '../../data/app_images.dart';
import '../../theme/app_color.dart';
import '../webview_android/webview_android.dart';
import '../webview_desktop/webview_desktop.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5))
        .then((value) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Platform.isAndroid
                    ? LoadAndroid(loadUrl: AppInfo.webUrl)
                    : Platform.isWindows
                        ? LoadDesktop(loadUrl: AppInfo.webUrl)
                        :   const BlankScreen()),
            (route) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 2.5,
                  child: Image.asset(AppImages.splashLogo)),
              const Spacer(),
              Text(AppInfo.appName,
                  style: const TextStyle(color: AppColor.kGreyColor)),
              Text('Version:${AppInfo.appVersion}',
                  style: const TextStyle(color: AppColor.kGreyColor)),
            ],
          ),
        ),
      ),
    );
  }
}