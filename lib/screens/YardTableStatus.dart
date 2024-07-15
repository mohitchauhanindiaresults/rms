import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rms/utils/Constant.dart';
import 'package:rms/utils/Utils.dart';
import '../utils/Tint.dart';
import 'LoginPage.dart';

class YardTableStatus extends StatefulWidget {
  @override
  _YardTableStatusState createState() => _YardTableStatusState();
}

class _YardTableStatusState extends State<YardTableStatus> {
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<TableReservation> reservations = [];
  String userId = '';
  String apiToken = '';

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    initiate();
  }

  Future<void> fetchData() async {
    print(userId);
    print(apiToken + "fsdsdvcd");
    print(selectedDate);
    final response = await http.post(
      Uri.parse('https://abc.charumindworks.com/inventory/api/v1/tablereservationstatus/yard'),
      body: {
        'user_id': userId, // Replace with actual user ID
        'apiToken': apiToken, // Replace with actual API token
        'date': dateController.text, // Replace with actual API token
      },
    );
    Utils.printLongString(response.body + 'dsvsdvv');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

        if(data['status']==200){
          //   Fluttertoast.showToast(msg: data['message']);
          setState(() {
            reservations = (data['ReservationData'] as List)
                .map((item) => TableReservation.fromJson(item))
                .toList();
          });

        }else if(data['status']==0){
          Fluttertoast.showToast(msg: data['message']);
          Utils.navigateToPage(context, LoginPage());
        }else{
          Fluttertoast.showToast(msg: data['message']);
        }


    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yard Table Status',
          style: TextStyle(
              fontFamily: 'Gilroy', fontSize: 20, color: Colors.white),
        ),
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
                  _buildDateSearch(),
                  SizedBox(height: 10),
                  ...reservations.map((reservation) =>
                      _buildTableCard(

                        reservation.reservationNumber.isEmpty ? 'Available' : 'Reserved',
                        '${reservation.tableNumber} - ${reservation.tableLocation} - ${reservation.capacity} Person',
                        reservation.reservationNumber.isEmpty ? null : ReservationDetails(
                          id: reservation.id.toString(),
                          name: reservation.reservationName,
                          phoneNumber: reservation.reservationMobile,
                          time: '${Utils.convertDateAndTime(reservation.reservationTime)} - ${Utils.convertDate(reservation.reservationEndTime)}',
                        ),
                        reservation.allBookings,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSearch() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithIcon(dateController, 'Date', Icons.calendar_today, () => _selectDate(context)),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithIcon(TextEditingController controller, String hintText, IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            prefixIcon: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard(String status, String tableInfo, ReservationDetails? details, List<Booking> allBookings) {
    return Card(
      color: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: status == 'Available' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: Colors.white)),
                ),
                Spacer(),
                if (status == 'Reserved')
                  Icon(Icons.calendar_today, color: Colors.red),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/images/table.png', // Placeholder for table image
              height: 50,
            ),
            SizedBox(height: 10),
            Text(tableInfo, style: TextStyle(color: Colors.white, fontSize: 16)),
            if (details != null) ...[
              SizedBox(height: 10),
              Text('ID: ${details.id}', style: TextStyle(color: Colors.white)),
              Text('Name: ${details.name}', style: TextStyle(color: Colors.white)),
              Text('Phone: ${details.phoneNumber}', style: TextStyle(color: Colors.white)),
              Text('Time: ${details.time}', style: TextStyle(color: Colors.white)),
            ],
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showBookingsDialog(context, allBookings);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                ),
                child: Text('View Bookings', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initiate() async {
    userId = (await Utils.getStringFromPrefs(Constant.user_id))!;
    apiToken = (await Utils.getStringFromPrefs(Constant.api_token))!;
    Timer(Duration(milliseconds: 50), () async {
      fetchData();
    });
  }

  void _showBookingsDialog(BuildContext context, List<Booking> bookings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bookings'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                final booking = bookings[index];
                return ListTile(
                  title: Text('${booking.firstName} ${booking.lastName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reservation Details'),
                      Text('Booking Date Time: ${Utils.convertDate(booking.time)}'),
                      Text('Reservation Date Time: ${Utils.convertDate(booking.endTime)}'),
                      Text('Persons: ${booking.noOffPerson}'),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
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
  }
}

class TableReservation {
  final int id;
  final String tableNumber;
  final String tableLocation;
  final String capacity;
  final String reservationNumber; // Changed from status to reservationNumber
  final String reservationName;
  final String reservationMobile;
  final String reservationTime;
  final String reservationEndTime;
  final List<Booking> allBookings;

  TableReservation({
    required this.id,
    required this.tableNumber,
    required this.tableLocation,
    required this.capacity,
    required this.reservationNumber, // Changed from status to reservationNumber
    required this.reservationName,
    required this.reservationMobile,
    required this.reservationTime,
    required this.reservationEndTime,
    required this.allBookings,
  });

  factory TableReservation.fromJson(Map<String, dynamic> json) {
    return TableReservation(
      id: json['id'],
      tableNumber: json['table_number'],
      tableLocation: json['table_location'],
      capacity: json['capacity'],
      reservationNumber: json['reservation_number'], // Changed from status to reservationNumber
      reservationName: json['reservation_name'],
      reservationMobile: json['reservation_mobile'],
      reservationTime: json['reservation_time'],
      reservationEndTime: json['reservation_end_time'],
      allBookings: (json['AllBookings'] as List)
          .map((booking) => Booking.fromJson(booking))
          .toList(),
    );
  }
}

class Booking {
  final String firstName;
  final String lastName;
  final String time;
  final String endTime;
  final int noOffPerson;

  Booking({
    required this.firstName,
    required this.lastName,
    required this.time,
    required this.endTime,
    required this.noOffPerson,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      firstName: json['first_name'],
      lastName: json['last_name'],
      time: json['time'],
      endTime: json['end_time'],
      noOffPerson: json['no_off_person'],
    );
  }
}

class ReservationDetails {
  final String id;
  final String name;
  final String phoneNumber;
  final String time;

  ReservationDetails({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.time,
  });
}
