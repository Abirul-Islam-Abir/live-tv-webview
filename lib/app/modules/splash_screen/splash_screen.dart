import 'package:flutter/material.dart';

import '../../app_info/app_info.dart';
import '../../data/app_images.dart';
import '../../theme/app_color.dart';
import '../webview/webview.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 4)).then(
          (value) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoadTv(
            loadUrl: AppInfo.webUrl,
          ),
        ),
      ),
    );
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
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.width / 3.5,
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