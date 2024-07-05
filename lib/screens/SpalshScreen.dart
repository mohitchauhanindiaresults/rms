import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rms/screens/LoginPage.dart';
import 'package:rms/screens/ReservationPage.dart';
import 'package:rms/utils/Constant.dart';
import 'package:rms/utils/Utils.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() {
    Future.delayed(Duration(seconds: 5), () async {
      // Navigate to the desired screen
      String? isLogin = await Utils.getStringFromPrefs(Constant.ISLOGINFORFIRSTTIME);
      if (isLogin == "true") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReservationPage(), // Replace with your next screen widget),);
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(), // Replace with your next screen widget
          ),
        );
      }
      print("12345678987654321234567");
    });  }

  _navigateToNextScreen() {
    Utils.navigateToPage(context, LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/gifs/short.gif',
              fit: BoxFit.cover,
            ),
          ),

        ],
      ),
    );
  }
}



