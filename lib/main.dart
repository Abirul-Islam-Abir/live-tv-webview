import "package:flutter/material.dart";

import "app/modules/splash_screen/splash_screen.dart";

void main() async {
  // For full-screen example
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}