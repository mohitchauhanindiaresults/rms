import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:rms/utils/Constant.dart';
import '../utils/Utils.dart';
import 'AssignTableList.dart';

class AssignTable extends StatefulWidget {
  @override
  _AssignTableState createState() => _AssignTableState();
}

class _AssignTableState extends State<AssignTable> {
  List<dynamic> reservations = [];
  String user_id = '';
  String apiToken = '';
  String selectedDate = Utils.getCurrentFormattedDate() ;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initate();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          child: SpinKitFadingCircle(
            color: Colors.pink,
            size: 50.0,
          ),
          onWillPop: () async => false,
        );
      },
    );

    final response = await http.post(
      Uri.parse(
          'https://abc.charumindworks.com/inventory/api/v1/assigntablelist'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id,
        'apiToken': apiToken,
        'date': selectedDate,
      }),
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        reservations = data['ReservationData'];
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Table',
            style: TextStyle(
                fontFamily: 'Gilroy', fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.pink,
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
                                    primaryColor: Colors.pink,
                                    backgroundColor: Colors.pink,
                                    colorScheme:
                                        ColorScheme.light(primary: Colors.pink),
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
                                    cursorColor: Colors.pink,
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
          _buildTableData(reservation),
          _buildActionButtons(reservation),
        ],
      ),
    );
  }

  Widget _buildTableData(Map<String, dynamic> reservation) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reservation['reservation_number'].toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          SizedBox(height: 5),
          _buildDetailRow('Guest Name',
              '${reservation['first_name']} ${reservation['last_name']}'),
          SizedBox(height: 5),
          _buildDetailRow('Phone Number', reservation['mobile']),
          SizedBox(height: 5),
          _buildDetailRow('No. of Person', reservation['no_off_person'].toString()),
          SizedBox(height: 5),
          _buildDetailRow('Booking Date', reservation['date']),
          SizedBox(height: 5),
          _buildDetailRow('Booking Time', reservation['time']),
          SizedBox(height: 5),
          _buildDetailRow('Table Location', reservation['table_location']),
          SizedBox(height: 5),
          _buildDetailRow('Discount', '${reservation['discount']}'),
          SizedBox(height: 5),
          _buildDetailRowReferance('Reference', reservation['reference'].toString()),
          SizedBox(height: 10),
        ],
      ),
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
        Text(value,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 14)),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> reservation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Utils.navigateToPage(context, AssignTableList(reservationNumber: reservation['reservation_number'].toString(), mobileNumber: reservation['mobile'].toString(), bookingDateTime:  reservation['date'].toString()+" "+reservation['time'].toString()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
          ),
          child: Text('Assign Table', style: TextStyle(fontFamily: 'Gilroy')),
        ),
        ElevatedButton(
          onPressed: () {
            // Add functionality for submitting here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Text('Submit', style: TextStyle(fontFamily: 'Gilroy')),
        ),
      ],
    );
  }

  Future<void> initate() async {

    user_id = (await Utils.getStringFromPrefs(Constant.user_id))!;
    apiToken = (await Utils.getStringFromPrefs(Constant.api_token))!;
    Timer(Duration(milliseconds: 50), () async {
      fetchReservations();
    });
  }
}
