import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart' show parse;
import 'package:rms/screens/AlibonTableStatus.dart';
import 'package:rms/screens/AssignTable.dart';
import 'package:rms/screens/Billing.dart';
import 'package:rms/screens/LoginPage.dart';
import 'package:rms/screens/NoShowData.dart';
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
  TextEditingController referance = TextEditingController();
  bool referenceVisiblity=false;
  List<TableRow> rows=[];
  bool bookingHistory=false;
  int lastStatus=0;
  Timer? _debounceTimer;
  bool _isCooldown = false;

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
                  Utils.navigateToPage(context, AssignTable());
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
                title: Text('Alibon Table Status'),
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
                  Utils.navigateToPage(context, NoShowData());
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_rounded),
                title: Text('Logout'),
                onTap: () {
                  Utils.saveStringToPrefs(Constant.ISLOGINFORFIRSTTIME, "false");

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
                    Visibility(
                        visible: referenceVisiblity,
                        child: _buildReferanceDropdown()),
                    SizedBox(height: 20),
                    _buildMobileFieldList(_mobileNumberController, 'Mobile Number'),
                    SizedBox(height: 20),
                    _buildTextField(_firstNameController, 'First Name'),
                    SizedBox(height: 20),
                    _buildTextField(_lastNameController, 'Last Name'),
                    SizedBox(height:4),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Previous Bookings'),
                                contentPadding: EdgeInsets.zero, // Remove default padding
                                content: SingleChildScrollView(
                                  child: Table(
                                    border: TableBorder.all(), // Add border to the table (optional)
                                    children: rows,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );

                            },
                          );
                        },
                        child: Visibility(
                          visible: bookingHistory,
                          child: Text(
                            'View Previous Bookings',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white, // Set underline color to white
                              decorationThickness: 1.5, // Optional: Adjust thickness of underline
                            ),
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 20),
                    _buildTimeDatePicker(),
                    SizedBox(height: 20),
                    _buildMobileField(_numberOfPersonController, 'No. of Person'),
                    SizedBox(height: 20),
                    _buildDiscountDropdown(),
                    SizedBox(height: 20),
                    _buildBookNowButton(),
                    SizedBox(height: 20),
               //     HtmlTableDisplay(htmlData: htmlData)


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
                'YARD',
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
                'ALIBON',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Gilroy', fontSize: 14),
              ),
              value: 'Alibon',
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
                  referenceVisiblity=false;

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
              ///\  overflow: TextOverflow.ellipsis,
              ),
              value: 'Pre Reservation',
              groupValue: _reservationType,
              onChanged: (value) {
                setState(() {
                  _reservationType = value!;
                  referenceVisiblity=true;
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
  Widget _buildMobileFieldList(TextEditingController controller, String hintText) {
    controller.addListener(() {
      if (controller.text.length == 10) {
        bookingHistory=true;

        previosData(context,controller.text);

        setState(() {
        });


      }else{
        bookingHistory=false;
      }
    });

    return Container(
      height: 57,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.3),
        border: Border.all(color: Colors.white),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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
  Widget _buildMobileField(TextEditingController controller, String hintText) {
    return Container(
      height: 57,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.3),
        border: Border.all(color: Colors.white),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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
                    child: IgnorePointer(
                      child: TextField(
                        controller: _timeController,
                        cursorColor: Color(0xFFeb3254),
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Gilroy'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: 'Time',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                          ),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                      ),
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
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: Color(0xFFeb3254),
                      backgroundColor: Color(0xFFeb3254),
                      colorScheme: ColorScheme.light(primary: Color(0xFFeb3254)),
                      buttonTheme: ButtonThemeData(
                        textTheme: ButtonTextTheme.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);

                if (pickedDate.isBefore(today)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a future date')),
                  );
                } else {
                  setState(() {
                    _dateController.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  });
                }
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
                    child: IgnorePointer(
                      child: TextField(
                        controller: _dateController,
                        cursorColor: Color(0xFFeb3254),
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Gilroy'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: 'Date',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                          ),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                      ),
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
        'NC',
        'EO',
        'Imperial Club'
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
  Widget _buildReferanceDropdown() {
    return DropdownButtonFormField<String>(
      style: TextStyle(color: Colors.pink, fontFamily: 'Gilroy'),
      value: referance.text.isNotEmpty ? referance.text : null,
      onChanged: (String? value) {
        setState(() {
          referance.text = value!;
        });
      },
      items: [
        'Pranav Sir',
        'Pallavi Maam',
        'Sagar Sir',
        'Saadgi Maam',
        'Sumit Sir ',
        'Rashi Maam',
        'Mohit Sir',
        'Vikas',
        'Zomato',
        'Dineout',
        'Other'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Reference',
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
            } else if (_reservationType == null || _reservationType.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Reservation Type Cannot be empty");
            } else if (_selectedLocation == null || _selectedLocation.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Table Location Cannot be empty");
            } else if (_mobileNumberController.text.isEmpty) {
              Utils.showAlertDialogError(
                  context, "Alert", "Mobile Number Cannot be empty");
            }  else if (_mobileNumberController.text.length!=10) {
              Utils.showAlertDialogError(
                  context, "Alert", "Mobile Number is not valid");
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
            }
            // else if (sourceController.text == null || sourceController.text.isEmpty) {
            //   Utils.showAlertDialogError(
            //       context, "Alert", "Discount Cannot be empty");
            // }
            else if (_mobileNumberController.text.length != 10) {
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
      print(sourceController.text+"fefvvevfev");
      String discount="";
      if(sourceController.text=="" ){
        discount="N/A";
      }else{
        discount=sourceController.text;
      }
      print(discount+'sdfwefvef');


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
        "discount":  discount,
        "reference": referance.text,
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
        }else if(status==0){
          Fluttertoast.showToast(msg: message);
          Utils.navigateToPage(context, LoginPage());
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

  Future<void> previosData(BuildContext context, String mobile) async {
    if (_isCooldown) return; // Ignore if cooldown is active

    // Set the cooldown flag
    _isCooldown = true;

    // Start a timer for 5 seconds to reset the cooldown flag
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(seconds: 3), () {
      _isCooldown = false;
    });

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
        "mobile": mobile,
      };

      final response = await dio.post(
        Constant.BASE_URL + "getcustomerdata",
        data: data,
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        print(response.data);
        Map<String, dynamic> responseObject = jsonDecode(response.toString());
        int status = responseObject['status'];
        String message = responseObject['message'];

        if (status == 200) {
          String htmlData = responseObject['html'];
          _firstNameController.text = responseObject['first_name'];
          _lastNameController.text = responseObject['last_name'];
          lastStatus = responseObject['last_status'];

          rows = _parseHtmlToTableRows(htmlData);

          if(htmlData.isEmpty){
            //   print("data is empty");
            //  print("gsdfvdfvfd");
            bookingHistory=false;
          }else {
            //  print("data is full");
            //  print("gsdfvdfvfd");
            bookingHistory = true;
          }
          checkBookingStatus(lastStatus);
        } else if (status == 0) {
          Fluttertoast.showToast(msg: message);
          Utils.navigateToPage(context, LoginPage());
        } else {
          Fluttertoast.showToast(msg: "Oops.. Something went wrong!");
        }
      } else {
        Fluttertoast.showToast(msg: "Oops.. Something went wrong!");
      }
    } catch (e) {
    //  Navigator.pop(context);
     // Fluttertoast.showToast(msg: "Oops.. Something went wrong!");
      print("Error: $e");
    }
  }



  void checkBookingStatus(int status) {
    if (status == 8) {
      // Show popup for "No show"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notice'),
            content: Text('Your last booking is marked as No show'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (status == 9) {
      // Show popup for "Cancelled"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notice'),
            content: Text('Your last booking is marked as Cancelled'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  List<TableRow> _parseHtmlToTableRows(String htmlData) {
    var document = parse(htmlData);
    var rows = document.getElementsByTagName('tr');

    return rows.map((row) {
      var cells = row.getElementsByTagName('td');
      if (cells.isEmpty) {
        cells = row.getElementsByTagName('th'); // Handle header row
      }

      return TableRow(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white), // White border
        ),
        children: cells.map((cell) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.25, // Adjust width as needed
            child: Text(
              cell.text.trim(),
              style: TextStyle(fontSize: 12, color: Colors.black), // Black text
            ),
          );
        }).toList(),
      );
    }).toList();
  }


  Future<void> initiate() async {
    email = (await Utils.getStringFromPrefs(Constant.user_id))!;
    password = (await Utils.getStringFromPrefs(Constant.api_token))!;
    _dateController.text = Utils.getCurrentFormattedDate();

    print(email+"check1");
    print(password);
  }
}
