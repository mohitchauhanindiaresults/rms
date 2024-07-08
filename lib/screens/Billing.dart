import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/Utils.dart';

class Billing extends StatefulWidget {
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController billAmountController = TextEditingController();

  String reservationNumber = '';
  String customerName = '';
  String customerPhone = '';
  String reservationDate = '';
  String reservationTime = '';
  String discount = '';
  String reference = '';
  String tableInfo = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController.text=Utils.getCurrentFormattedDate();
    _fetchBillDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Settlement', style: TextStyle(fontFamily: 'Gilroy', fontSize: 20, color: Colors.white)),
        backgroundColor: Color(0xFFC62828),
        iconTheme: IconThemeData(
          color: Colors.white,
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
                  _buildReservationDetails(),
                  SizedBox(height: 10),
                  _buildBillInputs(),
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
          child: _buildTextFieldWithIcon(dateController, 'Date', Icons.calendar_today),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _fetchBillDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          ),
          child: Text('Search', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy')),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithIcon(TextEditingController controller, String hintText, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReservationDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservation Details', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          SizedBox(height: 10),
          _buildDetailRow('Reservation Number', reservationNumber),
          SizedBox(height: 5),
          _buildDetailRow('Name', customerName),
          SizedBox(height: 5),
          _buildDetailRow('Phone Number', customerPhone),
          SizedBox(height: 5),
          _buildDetailRow('Date', reservationDate),
          SizedBox(height: 5),
          _buildDetailRow('Time', reservationTime),
          SizedBox(height: 5),
          _buildDetailRow('Discount', '$discount%'),
          SizedBox(height: 5),
          _buildDetailRow('Reference', reference),
          SizedBox(height: 5),
          _buildDetailRow('Table Info', tableInfo),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 14)),
        Text(value, style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 14)),
      ],
    );
  }

  Widget _buildBillInputs() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(billNumberController, 'Enter Bill Number'),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildTextField(billAmountController, 'Enter Bill Amount'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Handle bill submission
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            ),
            child: Text('Submit', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy')),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _fetchBillDetails() async {
    final response = await http.post(
      Uri.parse('https://abc.charumindworks.com/inventory/api/v1/billsettlementlist'),
      body: {
        'user_id': '20',
        'apiToken': '557f2929033db27b71f7c0d09b0c1b5c27e5677395fe78e812c16f68f5331222',
        'date': dateController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['BillListData'][0];

      setState(() {
        reservationNumber = data['reservation_number'];
        customerName = '${data['first_name']} ${data['last_name']}';
        customerPhone = data['mobile'];
        reservationDate = data['date'];
        reservationTime = data['time'];
        discount = data['discount'];
        reference = data['reference'];
        tableInfo = '${data['table_number']} - ${data['table_location']}';
      });
    } else {
      // Handle error
      print('Failed to fetch bill details');
    }
  }
}
