import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rms/screens/ChangeTableList.dart';
import 'package:rms/screens/LoginPage.dart';
import 'package:rms/utils/Constant.dart';
import 'package:rms/utils/Tint.dart';
import 'package:rms/utils/Utils.dart';

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List<dynamic> reservations = [];
  Map<String, String> totalPerson = {};
  String user_id = '';
  String password = '';
  String statusSelect = 'Select Status';
  String statusLable = 'Select Status';
  String selectedDate = Utils.getCurrentFormattedDate();
  TextEditingController _dateController = TextEditingController();
  TextEditingController numberOfpersons = TextEditingController();

  @override
  void initState() {
    super.initState();
    initiate();
  }

  Future<void> fetchReservations() async {
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

    print(statusSelect+"ffffff");
    if (statusSelect == 'Not Check-In') {
      statusSelect = '2';
    } else if(statusSelect == 'Check-In'){
      statusSelect = '1';
    }else{
      statusSelect = '';

    }

    final response = await http.post(
      Uri.parse('https://abc.charumindworks.com/inventory/api/v1/getallreservations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id, // replace with actual user_id
        'apiToken': password, // replace with actual token
        'date': selectedDate,
        'status': statusSelect, // replace with actual status
      }),
    );
    Navigator.pop(context);
    Utils.printLongString(response.body+"wqewrqerttr");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
     print(data);






     if(data['status']==200){
    //   Fluttertoast.showToast(msg: data['message']);
       setState(() {
         reservations = data['ReservationData'];
         totalPerson = {
           for (var item in data['totalPerson'])
             item['table_location']: item['total']
         };
       });

     }else if(data['status']==0){
       Fluttertoast.showToast(msg: data['message']);
       Utils.navigateToPage(context, LoginPage());
     }else{
       Fluttertoast.showToast(msg: data['message']);
     }








    } else {
      Fluttertoast.showToast(msg: 'Something went wrong!!');
      throw Exception('Failed to load reservations');
    }
  }
  Future<void> cancleReservation(int id) async {
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
    final response = await http.post(
      Uri.parse(
          'https://abc.charumindworks.com/inventory/api/v1/cancelreservations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id,
        'apiToken': password, // replace with actual token
        'id': id.toString()
      }),
    );
    Navigator.pop(context);
    fetchReservations();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      // setState(() {
      //   reservations = data['ReservationData'];
      //   totalPerson = {
      //     for (var item in data['totalPerson']) item['table_location']: item['total']
      //   };
      // });
    } else {
      throw Exception('Failed to load reservations');
    }
  }
  Future<void> checkInReservation(int id,numberOfPersons) async {
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
    final response = await http.post(
      Uri.parse(
          'https://abc.charumindworks.com/inventory/api/v1/checkin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id,
        'apiToken': password, // replace with actual token
        'id': id.toString(),
        'no_off_person': numberOfPersons
      }),
    );
    Navigator.pop(context);
    fetchReservations();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      // setState(() {
      //   reservations = data['ReservationData'];
      //   totalPerson = {
      //     for (var item in data['totalPerson']) item['table_location']: item['total']
      //   };
      // });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation List',
            style: TextStyle(fontFamily: 'Gilroy', fontSize: 20, color: Colors.white)),
        backgroundColor: Color(Tint.Pink),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the icon color here
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
                  Color(0xFF191B2F).withOpacity(0.7),
                  Color(0xFF191B2F).withOpacity(0.7),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDropdownButton(statusSelect),
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
                                    colorScheme: ColorScheme.light(
                                        primary: Color(0xFFeb3254)),
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
                                selectedDate = _dateController.text;
                                fetchReservations();
                                print("Selected date: ${_dateController.text}");
                              });
                            }
                          },
                          child: Container(
                            height: 49,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white.withOpacity(0.3),
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
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gilroy'),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintText: selectedDate,
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gilroy',
                                      ),
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
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoBox(' Yard ', totalPerson['YARD'] ?? '0'),
                      _buildInfoBox('Alibon', totalPerson['ALIBON'] ?? '0'),
                      _buildInfoBox(
                          '      Total      ',
                          (int.tryParse(totalPerson['YARD'] ?? '0')! + int.tryParse(totalPerson['ALIBON'] ?? '0')!)
                              .toString()),
                    ],
                  ),
                  SizedBox(height: 10),
                  ...reservations.map((reservation) {
                    return _buildReservationContainer(context, reservation);
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            statusLable,
            style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          ),
          dropdownColor: Colors.black,
          items: <String>['Select Status', 'Check-In', 'Not Check-In']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            statusSelect = value!;
            statusLable = value!;
            setState(() {
              fetchReservations();
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(TextEditingController controller, String hintText, IconData icon) {
    return Container(
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(fontFamily: 'Gilroy'),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Gilroy'),
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationContainer(
      BuildContext context, Map<String, dynamic> reservation) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          _buildReservationDetails(reservation),
          SizedBox(height: 10),
          _buildBookingDateTime(reservation),
          SizedBox(height: 10),
          _buildLocationStatus(reservation),
          SizedBox(height: 10),
          _buildStatusButtons(context, reservation),
        ],
      ),
    );
  }

  Widget _buildReservationDetails(Map<String, dynamic> reservation) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservation Details',
              style: TextStyle(
                  color: Color(Tint.LightBlack),
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          _buildDetailRow('Name',
              '${reservation['first_name']} ${reservation['last_name']}'),
          SizedBox(height: 5),
          _buildDetailRow('Phone Number', reservation['mobile']),
          SizedBox(height: 5),
          _buildDetailRow('Discount', '${reservation['discount']}'),
          SizedBox(height: 5),
          _buildDetailRow(
              'No. of Person', reservation['no_off_person'].toString()),
          SizedBox(height: 5),
          /// if reference is null make the valve N/A of reference
          _buildDetailRowReferance('Reference', reservation['reference'].toString()),

          SizedBox(height: 5),
          _buildDetailRow('Reservation Number', reservation['reservation_number'].toString()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        Text(
          (value == null || value.isEmpty) ? 'N/A' : value,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gilroy',
            fontSize: 14,
          ),
        ),      ],
    );
  }
  Widget _buildDetailRowTime(String title, String value) {
    String formattedValue;
    try {
      final time = DateFormat('HH:mm:ss').parse(value);
      formattedValue = DateFormat('hh:mm a').format(time);
    } catch (e) {
      formattedValue = 'N/A';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        Text(
          formattedValue,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gilroy',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRowReferance(String title, String value) {
    // Print statement for debugging
    print('Title: $title, Value: $value');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gilroy',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          (value == "null" ) ?  'N/A':value,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gilroy',
            fontSize: 14,
          ),
        ),
      ],
    );
  }


  Widget _buildBookingDateTime(Map<String, dynamic> reservation) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Date Time',
              style: TextStyle(
                  color: Color(Tint.LightBlack),
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          _buildDetailRow('Date', reservation['date']),
          SizedBox(height: 5),
          _buildDetailRowTime('Time', reservation['time']),
        ],
      ),
    );
  }

  Widget _buildLocationStatus(Map<String, dynamic> reservation) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Location', reservation['table_location']),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(BuildContext context, Map<String, dynamic> reservation) {
    String statusLabel;
    Color statusColor;

    if (reservation['status'] == 0 && reservation['check_in'] != null && reservation['check_in'].isNotEmpty) {
      statusLabel = 'Check-In ${Utils.convertDateAndTime(reservation['check_in'])}';
      statusColor = Colors.green;
    } else {
      switch (reservation['status']) {
        case 0:
          statusLabel = 'Waiting For Check-In';
          statusColor = Colors.green;
          numberOfpersons.text = reservation["no_off_person"].toString();

          break;
        case 1:
          statusLabel = 'Table Allotted';
          statusColor = Colors.orange;
          break;
        case 8:
          statusLabel = 'No show';
          statusColor = Colors.black;
          break;
        case 9:
          statusLabel = 'Booking Canceled';
          statusColor = Colors.red;
          break;
        default:
          statusLabel = 'Billing Completed';
          statusColor = Colors.blue;
          break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          statusLabel,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 16,
            color: statusColor,
          ),
        ),


    if (reservation['status'] == 0 && (reservation['check_in'] == null || reservation['check_in'].isEmpty)) ...[
          SizedBox(height: 10),

    TextField(
            controller: numberOfpersons,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(
              color: Colors.white, // Text color
              fontFamily: 'Gilroy',
            ),
            cursorColor: Colors.white, // Cursor color
            decoration: InputDecoration(
              hintText: 'No of Persons',
              hintStyle: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
              filled: true,
              fillColor: Colors.white.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (numberOfpersons.text.isEmpty) {
                    Utils.showAlertDialogError(context, "Alert", "No of persons required");
                  } else {
                    checkInReservation(reservation['id'], numberOfpersons.text);
                  }
                },
                child: Text(
                  'Check-In',
                  style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Implement cancellation logic here
                  cancleReservation(reservation['id']);
                  // You can add more functionality here as needed
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
            ],
          ),
        ],
        if (reservation['status'] == 1) ...[
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {

              Utils.navigateToPage(context, ChangeTableList(reservationId: reservation['id'].toString(),reservationNumber: reservation['reservation_number'].toString(), mobileNumber: reservation['mobile'].toString(), bookingDate:  reservation['date'].toString(),bookingTime:reservation['time'].toString()));
              print('Change table for reservation ID: ${reservation['id']}');
              // You can add more functionality here as needed
            },
            child: Text(
              'Change Table',
              style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            ),
          ),
        ],
      ],
    );
  }





  Future<void> initiate() async {
    user_id = (await Utils.getStringFromPrefs(Constant.user_id))!;
    password = (await Utils.getStringFromPrefs(Constant.api_token))!;
    print(user_id + "check1");
    print(password);

    fetchReservations();
  }
}
