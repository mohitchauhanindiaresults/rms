import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rms/screens/AlibonTableStatus.dart';
import 'package:rms/screens/Billing.dart';
import 'package:rms/screens/LoginPage.dart';
import 'package:rms/screens/ReservationList.dart';
import 'package:rms/screens/YardTableStatus.dart';
import 'package:rms/utils/Tint.dart';
import 'package:rms/utils/Utils.dart';

import '../utils/Constant.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String _selectedLocation = '';
  String _reservationType = '';
  String email = '';
  String password = '';
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _numberOfPersonController = TextEditingController();
  String _selectedDiscount = "Select Discounts"; // Or any other valid discount
  TextEditingController sourceController = TextEditingController();

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
        appBar: AppBar(
          title: Text(
            'Make A Reservation',
            style: TextStyle(
                fontFamily: 'Gilroy', fontSize: 20, color: Colors.white),
          ),
          backgroundColor: Color(Tint.Pink),
          iconTheme: IconThemeData(
            color: Colors.white, // Change the icon color here
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(Tint.Pink),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Restaurant \nManagement System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Make a reservation'),
                onTap: () {
                  Utils.navigateToPage(context, ReservationPage());

                  // Handle dashboard tap
                },
              ),
              ListTile(
                leading: Icon(Icons.restaurant),
                title: Text('Reservation List'),
                onTap: () {
                  Utils.navigateToPage(context, ReservationList());
                  // Handle reservation list tap
                },
              ),
              ListTile(
                leading: Icon(Icons.table_bar),
                title: Text('Assign Table'),
                onTap: () {
                  // Handle assign table tap
                },
              ),
              ListTile(
                leading: Icon(Icons.table_restaurant),
                title: Text('Yard Table Status'),
                onTap: () {
                  Utils.navigateToPage(context, YardTableStatus());
                },
              ),
              ListTile(
                leading: Icon(Icons.table_restaurant_outlined),
                title: Text('Albion Table Status'),
                onTap: () {
                  Utils.navigateToPage(context, AlibonTableStatus());
                },
              ),
              ListTile(
                leading: Icon(Icons.currency_rupee),
                title: Text('Bill Settlement'),
                onTap: () {
                  Utils.navigateToPage(context, Billing());

                  // Handle bill settlement tap
                },
              ),
              ListTile(
                leading: Icon(Icons.hourglass_empty),
                title: Text('No Show'),
                onTap: () {
                  // Handle no show tap
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_rounded),
                title: Text('Logout'),
                onTap: () {
                  Utils.saveStringToPrefs(Constant.ISLOGINFORFIRSTTIME, "true");

                  Utils.navigateToPage(context, LoginPage());
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroundlogin.png'),
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
                    //  Colors.white.withOpacity(0.5),
                    Color(0xFF191B2F).withOpacity(0.7),
                    Color(0xFF191B2F).withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildLocationSelector(),
                    SizedBox(height: 20),
                    _buildReservationTypeSelector(),
                    SizedBox(height: 20),
                    _buildTextField(_mobileNumberController, 'Mobile Number'),
                    SizedBox(height: 20),
                    _buildTextField(_firstNameController, 'First Name'),
                    SizedBox(height: 20),
                    _buildTextField(_lastNameController, 'Last Name'),
                    SizedBox(height: 20),
                    _buildTimeDatePicker(),
                    SizedBox(height: 20),
                    _buildTextField(_numberOfPersonController, 'No. of Person'),
                    SizedBox(height: 20),
                    _buildDiscountDropdown(),
                    SizedBox(height: 20),
                    _buildBookNowButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 7,
            child: RadioListTile(
              title: Text(
                'Yard',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 14),
              ),
              value: 'Yard',
              groupValue: _selectedLocation,
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value!;
                });
              },
              activeColor: Colors.white,
            ),
          ),
          Flexible(
            flex: 10,
            child: RadioListTile(
              title: Text(
                'Albion',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 14),
              ),
              value: 'Albion',
              groupValue: _selectedLocation,
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value!;
                });
              },
              activeColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationTypeSelector() {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 7,
            child: RadioListTile(
              title: Text(
                'Walk-in',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 14),
              ),
              value: 'Walk-in',
              groupValue: _reservationType,
              onChanged: (value) {
                setState(() {
                  _reservationType = value!;
                });
              },
              activeColor: Colors.white,
            ),
          ),
          Flexible(
            flex: 10,
            child: RadioListTile(
              title: Text(
                'Pre-Reservation',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              value: 'Pre Reservation',
              groupValue: _reservationType,
              onChanged: (value) {
                setState(() {
                  _reservationType = value!;
                });
              },
              activeColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      height: 57,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.3),
        border: Border.all(color: Colors.white),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTimeDatePicker() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: Color(0xFFeb3254),
                      backgroundColor: Color(0xFFeb3254),
                      colorScheme:
                          ColorScheme.light(primary: Color(0xFFeb3254)),
                      buttonTheme: ButtonThemeData(
                        textTheme: ButtonTextTheme.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedTime != null) {
                setState(() {
                  _timeController.text = pickedTime.format(context);
                });
              }
            },
            child: Container(
              height: 57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _timeController,
                      cursorColor: Color(0xFFeb3254),
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Time',
                        hintStyle: TextStyle(
                            color: Colors.white, fontFamily: 'Gilroy'),
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: Color(0xFFeb3254),
                      backgroundColor: Color(0xFFeb3254),
                      colorScheme:
                          ColorScheme.light(primary: Color(0xFFeb3254)),
                      buttonTheme: ButtonThemeData(
                        textTheme: ButtonTextTheme.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                setState(() {
                  _dateController.text =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                });
              }
            },
            child: Container(
              height: 57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.date_range, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      cursorColor: Color(0xFFeb3254),
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Date',
                        hintStyle: TextStyle(
                            color: Colors.white, fontFamily: 'Gilroy'),
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountDropdown() {
    return DropdownButtonFormField<String>(
      style: TextStyle(color: Colors.pink, fontFamily: 'Gilroy'),
      value: sourceController.text.isNotEmpty ? sourceController.text : null,
      onChanged: (String? value) {
        setState(() {
          sourceController.text = value!;
        });
      },
      items: [
        '5%',
        '10%',
        '15%',
        '20%',
        '25%',
        '30%',
        '35%',
        '40%',
        '45%',
        '50%',
        'NC'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Discount',
        labelStyle: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
  Widget _buildBookNowButton() {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        child: ElevatedButton(
          onPressed: () {
            if (_dateController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Date Cannot be empty");
            } else if (_mobileNumberController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Mobile Number Cannot be empty");
            } else if (_firstNameController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "First Name Cannot be empty");
            } else if (_lastNameController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Last Name Cannot be empty");
            } else if (_timeController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Time Cannot be empty");
            } else if (_numberOfPersonController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Number of Persons Cannot be empty");
            } else if (_reservationType == null || _reservationType.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Reservation Type Cannot be empty");
            } else if (_selectedLocation == null || _selectedLocation.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Table Location Cannot be empty");
            } else if (sourceController.text == null ||
                sourceController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Discount Cannot be empty");
            } else if (_mobileNumberController.text.length != 10) {
              Utils.showAlertDialogError(
                  context, "Alert", "Mobile number is not valid");
            } else {
              makeAreservation(context);
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
            'Book Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makeAreservation(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            child: SpinKitFadingCircle(
              color: Color(Tint.Pink),
              size: 50.0,
            ),
            onWillPop: () async => false,
          );
        },
      );

      final Dio dio = Dio();
      final data = {
        "user_id": email,
        "apiToken": password,
        "date": _dateController.text,
        "mobile": _mobileNumberController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "time": _timeController.text,
        "no_off_person": _numberOfPersonController.text,
        "type": _reservationType,
        "table_location": _selectedLocation,
        "discount": sourceController.text,
        "reference": "N/A",
      };

      final response = await dio.post(
        Constant.BASE_URL + "savereservation",
        data: data,
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        print(response.data);
        Map<String, dynamic> responseObject = jsonDecode(response.toString());
        int status = responseObject['status'];
        String message = responseObject['message'];


        if (status == 200) {
          Fluttertoast.showToast(msg: message);

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
    email = (await Utils.getStringFromPrefs(Constant.user_id))!;
    password = (await Utils.getStringFromPrefs(Constant.api_token))!;
  }
}