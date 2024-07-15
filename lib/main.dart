import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rms/screens/SpalshScreen.dart';
import 'package:rms/utils/theme.dart';
import 'platform_specific.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  platformSpecificFunction();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RMS',
      debugShowCheckedModeBanner: false,
      // routes: AppRoutes.routes,
      theme: appTheme,
      home: SplashScreen(),
    );
  }
}
