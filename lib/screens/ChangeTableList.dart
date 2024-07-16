import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rms/screens/ReservationPage.dart';
import 'package:rms/utils/Constant.dart';

import '../utils/Utils.dart';

class ChangeTableList extends StatefulWidget {
  final String reservationId;
  final String reservationNumber;
  final String mobileNumber;
  final String bookingDate;
  final String bookingTime;

  ChangeTableList({
    required this.reservationId,
    required this.reservationNumber,
    required this.mobileNumber,
    required this.bookingDate,
    required this.bookingTime,
  });

  @override
  _ChangeTableListState createState() => _ChangeTableListState();
}

class _ChangeTableListState extends State<ChangeTableList> {
  final String apiUrl = "https://abc.charumindworks.com/inventory/api/v1/assigntable/";
    String userId = '';
    String apiToken = '';

  List<TableData> tableList = [];
  ReservationData? reservationData;

  @override
  void initState() {
    super.initState();
    initiate();
  }

  Future<void> fetchTableData() async {
    print(apiUrl+widget.reservationNumber+'aaaaaaa');
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
      Uri.parse(apiUrl+widget.reservationNumber),
      body: {
        'user_id': userId,
        'apiToken': apiToken,
      },
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Utils.printLongString(response.body+"dscedcwe");
    //  print(response.body+"dscedcwe");
      setState(() {
        reservationData = ReservationData.fromJson(data['ReservationData'][0]);
        tableList = (data['TableList'] as List)
            .map((item) => TableData.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load table data');
    }
  }
  Future<void> saveTable(int Tableid) async {
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
    print(userId);
    print(apiToken);
    print(Tableid.toString());
    print(reservationData!.id.toString()+'1234567890');
    final response = await http.post(
      Uri.parse("https://abc.charumindworks.com/inventory/api/v1/saveassigntable"),
      body: {
        'user_id': userId,
        'apiToken': apiToken,
        'tableid': Tableid.toString(),
        'reservationid': reservationData!.id.toString(),
        'old_rv_id': widget.reservationId,
      },
    );
    Navigator.pop(context);
    print(response.body+'wefwfwefwfefw');

    if (response.statusCode == 200) {

    Utils.navigateToPage(context, ReservationPage());

    } else {
      throw Exception('Failed to load table data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Table',
            style: TextStyle(fontFamily: 'Gilroy', fontSize: 20, color: Colors.white)),
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
          reservationData == null
              ? Center(child: null)
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReservationInfo(),
                  SizedBox(height: 10),
                  _buildTableGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationInfo() {
    String formattedValue;
    try {
      final time = DateFormat('HH:mm:ss').parse(widget.bookingTime.toString());
      formattedValue = DateFormat('hh:mm a').format(time);
    } catch (e) {
      formattedValue = 'N/A';
    }
    return Card(
      color: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assign Table To ${reservationData!.firstName} ${reservationData!.lastName}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Reservation Number: ${widget.reservationNumber}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Mobile Number: ${widget.mobileNumber}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Reservation Date: ${widget.bookingDate}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Reservation Date: ${formattedValue}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 0.8,
      ),
      itemCount: tableList.length,
      itemBuilder: (context, index) {
        return Center(child: _buildTableCard(tableList[index]));
      },
    );
  }

  Widget _buildTableCard(TableData table) {
    return GestureDetector(
      onTap: () {
        print("Table ID: ${table.id}"); // Action when the card is tapped
        saveTable(table.id);
      },
      child: Center(
        child: Card(
          color: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                        decoration: BoxDecoration(
                          color: table.reservation_number != "" ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            table.reservation_number != "" ? 'Reserved' : 'Available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                if (table.reservation_number != "")
                  Text(
                    table.reservation_number.toString()+"\n"+table.reservation_name.toString()
                        +"\n"+table.reservation_mobile.toString()

                    , style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                SizedBox(height: 10),
                Text(
                  '${table.tableNumber} - ${table.tableLocation} - ${table.capacity} Person',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> initiate() async {
    userId = (await Utils.getStringFromPrefs(Constant.user_id))!;
    apiToken = (await Utils.getStringFromPrefs(Constant.api_token))!;
    Timer(Duration(milliseconds: 50), () async {
      fetchTableData();
    });
  }
}

class ReservationData {
  final int id;
  final String? reservationNumber;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? tableNumber;

  ReservationData({
    required this.id,
    this.reservationNumber,
    this.firstName,
    this.lastName,
    this.mobile,
    this.tableNumber,
  });

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      id: json['id'],
      reservationNumber: json['reservation_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobile: json['mobile'],
      tableNumber: json['table_number'],
    );
  }
}
class TableData {
  final int id;
  final String? tableNumber;
  final String? tableLocation;
  final String? capacity;
  final int? status;
  final String? reservation_number;
  final String? reservation_name;
  final String? reservation_mobile;

  TableData({
    required this.id,
    this.tableNumber,
    this.tableLocation,
    this.capacity,
    this.status,
    this.reservation_number,
    this.reservation_name,
    this.reservation_mobile,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'],
      tableNumber: json['table_number'],
      tableLocation: json['table_location'],
      capacity: json['capacity'],
      status: json['status'],
      reservation_number: json['reservation_number'],
      reservation_name: json['reservation_name'],
      reservation_mobile: json['reservation_mobile'],
    );
  }
}

