  import 'dart:convert';
import 'dart:io';
  
  import 'package:dio/dio.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_spinkit/flutter_spinkit.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:rms/utils/Constant.dart';
  import 'package:rms/utils/Tint.dart';
  
  import '../utils/Utils.dart';
  import 'ReservationPage.dart';
  
  class LoginPage extends StatefulWidget {
  
    @override
    State<LoginPage> createState() => _LoginPageState();
  }
  
  class _LoginPageState extends State<LoginPage> {
    bool _obscureText = true;
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiate();

  }
  
    @override
    Widget build(BuildContext context) {
      return WillPopScope(

        onWillPop: () async {
          exit(0);
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundlogin.png'), // Replace with your background image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.5), // Adjust the opacity and colors as needed
                      Color(0xFF191B2F).withOpacity(0.3), // Adjust the opacity and colors as needed
                      Color(0xFF191B2F).withOpacity(0.9), // Adjust the opacity and colors as needed
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/loginicon.png',
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25    ,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10), // Adjust horizontal margin as needed
                      child: Container(
                        height: 57,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // Adjust corner radius as needed
                          color: Colors.white,
                          border: Border.all(color: Colors.white),  // Makes the border white

                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: TextField(
                          controller: email,
                          cursorColor: Colors.white,

                          style: TextStyle(color: Colors.white,fontFamily: 'Gilroy'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: 'Your email',

                            hintStyle: TextStyle(color: Colors.white,fontFamily: 'Gilroy'
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10), // Adjust horizontal margin as needed
                      child: Container(
                        height: 57,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // Adjust corner radius as needed
                          color: Colors.white,
                          border: Border.all(color: Colors.white),  // Makes the border white
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.3),
                            ],
                          ),
                        ),

                     child:  TextFormField(
                       controller: password,
                      cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureText,
                      ),

                    ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(height: 40),
                    Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          if(email.text.isEmpty){
                            Utils.showAlertDialogError(context, "Alert", "Email Cannot be empty");
                          }else if(password.text.isEmpty){
                            Utils.showAlertDialogError(context, "Alert", "Password Cannot be empty");
                          }else {
                            loginAPI(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(Tint.Pink),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Gilroy'
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  
    Future<void> loginAPI(BuildContext context) async {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              child: SpinKitFadingCircle(color: Color(Tint.Pink), size: 50.0,),
              onWillPop: () async => false,
            );
          },
        );
  
        final Dio dio = Dio();
        final data = {
          "username": email.text,
          "password": password.text,
        };
  
        final response = await dio.post(
          Constant.BASE_URL + "login",
          data: data,
        );
  
        Navigator.pop(context);
  
        if (response.statusCode == 200) {
          print(response.data);
          Map<String, dynamic> responseObject = jsonDecode(response.toString());
          int status = responseObject['status'];
          String message = responseObject['message'];
          int user_id = responseObject['user_id'];
          String api_token = responseObject['api_token'];

          if (status == 200) {
            Fluttertoast.showToast(msg: message);
            Utils.saveStringToPrefs(Constant.user_id, user_id.toString());
            Utils.saveStringToPrefs(Constant.api_token, api_token);
            Utils.saveStringToPrefs(Constant.email, email.text);
            Utils.saveStringToPrefs(Constant.password, password.text);
            Utils.saveStringToPrefs(Constant.ISLOGINFORFIRSTTIME, "true");
            Utils.navigateToPage(context, ReservationPage());
          } else {
            Fluttertoast.showToast(msg: "Oops.. Something went wrong!");
          }
        } else {
          Fluttertoast.showToast(msg: "Oops.. Something went wrong!111");
        }
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Oops.. Something went wrong!");
        print("Error: $e");
      }
    }

  Future<void> initiate() async {
      email.text=(await Utils.getStringFromPrefs(Constant.email))!;
      password.text=(await Utils.getStringFromPrefs(Constant.password))!;
  }
  
  }
