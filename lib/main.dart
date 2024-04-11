import "package:bitsdojo_window/bitsdojo_window.dart";
import "package:flutter/material.dart";

import "app/modules/splash_screen/splash_screen.dart";

void main() async {
  // For full-screen example
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: SplashScreen()));// Add this code below

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1080, 620);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "";
    win.show();
  });
}