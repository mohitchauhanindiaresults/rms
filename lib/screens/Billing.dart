import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rms/utils/Constant.dart';

import '../utils/Tint.dart';
import '../utils/Utils.dart';
import 'LoginPage.dart';
import 'ReservationPage.dart';

class Billing extends StatefulWidget {
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> billList = [];
  String userId = '';
  String apiToken = '';

  @override
  void initState() {
    super.initState();
    dateController.text = Utils.getCurrentFormattedDate();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Settlement', style: TextStyle(fontFamily: 'Gilroy', fontSize: 20, color: Colors.white)),
        backgroundColor: Color(Tint.Pink),
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
                  _buildBillList(),
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
        _fetchBillDetails();
      });
    }
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

  Widget _buildBillList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: billList.length,
      itemBuilder: (context, index) {
        final bill = billList[index];
        final TextEditingController numberOfPersonsController = TextEditingController();
        final TextEditingController billAmountController = TextEditingController();

        bool isBillComplete =
            bill['bill_number'] != null && bill['bill_amount'] != null;

        return Container(
          margin: EdgeInsets.only(bottom: 10),
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
              _buildDetailRow('Reservation Number', bill['reservation_number']),
              SizedBox(height: 5),
              _buildDetailRow('Name', '${bill['first_name']} ${bill['last_name']}'),
              SizedBox(height: 5),
              _buildDetailRow('Phone Number', bill['mobile']),
              SizedBox(height: 5),
              _buildDetailRow('Date', bill['date']),
              SizedBox(height: 5),
              _buildDetailRowTime('Time', bill['time']),
              SizedBox(height: 5),
              _buildDetailRow('Discount', '${bill['discount']}'),
              SizedBox(height: 5),
              _buildDetailRow('Reference', bill['reference'] ?? 'NA'),
              SizedBox(height: 5),
              _buildDetailRow('Table Info', '${bill['table_number']} - ${bill['table_location'] ?? ''}'),
              SizedBox(height: 10),
              isBillComplete
                  ? Column(
                      children: [
                        _buildDetailRow(
                            'Bill Number', bill['bill_number'] ?? 'NA'),
                        SizedBox(height: 5),
                        _buildDetailRow(
                            'Bill Amount', bill['bill_amount'] ?? 'NA'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 24.0),
                          ),
                          child: Text('Booking Complete',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Gilroy')),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildTextField(numberOfPersonsController,
                            'Enter Bill Number', TextInputType.number),
                        SizedBox(height: 10),
                        _buildTextField(billAmountController,
                            'Enter Bill Amount', TextInputType.number),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (numberOfPersonsController.text.isNotEmpty &&
                                billAmountController.text.isNotEmpty) {
                              print('Reservation ID: ${bill['id']}');
                              print(
                                  'No of Persons: ${numberOfPersonsController.text}');
                              print(
                                  'Bill Amount: ${billAmountController.text}');
                              _saveBillDetails(
                                  bill['id'].toString(),
                                  numberOfPersonsController.text,
                                  billAmountController.text);
                            } else {
                        print('Please fill in all fields');
                        Utils.showAlertDialogError(
                            context, "Alert", "Please fill all details");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 24.0),
                    ),
                    child: Text('Submit', style: TextStyle(
                        color: Colors.white, fontFamily: 'Gilroy')),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  Widget _buildDetailRowTime(String title, String value) {
    String formattedValue = Utils.convertDate(value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 14)),
        Text(formattedValue,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 14)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, TextInputType keyboardType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Gilroy',
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hintText,
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
    );
  }

  Future<void> _fetchBillDetails() async {
    final response = await http.post(
      Uri.parse('https://abc.charumindworks.com/inventory/api/v1/billsettlementlist'),
      body: {
        'user_id': userId,
        'apiToken': apiToken,
        'date': dateController.text,
      },
    );

    if (response.statusCode == 200) {
      final dataa = json.decode(response.body);
      //   print(response.body);
      Utils.printLongString(response.body);
      if(dataa['status']==200){
        //   Fluttertoast.showToast(msg: data['message']);
        final List<dynamic> data = json.decode(response.body)['BillListData'];

        setState(() {
          billList = data.map((bill) => bill as Map<String, dynamic>).toList();
        });
      }else if(dataa['status']==0){
        Fluttertoast.showToast(msg: dataa['message']);
        Utils.navigateToPage(context, LoginPage());
      }else{
        Fluttertoast.showToast(msg: dataa['message']);
      }

    } else {
      print('Failed to fetch bill details');
    }
  }

  Future<void> _saveBillDetails(String rvID,String number,String amount) async {
    final response = await http.post(
      Uri.parse('https://abc.charumindworks.com/inventory/api/v1/savebill'),
      body: {
        'user_id': userId,
        'apiToken': apiToken,
        'reservation_id': rvID,
        'bill_number':number,
        'bill_amount': amount,
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Billing Complete");
      Utils.navigateToPage(context, ReservationPage());
    } else {
      print('Failed to fetch bill details');
    }
  }


  Future<void> initiate() async {
    userId = (await Utils.getStringFromPrefs(Constant.user_id))!;
    apiToken = (await Utils.getStringFromPrefs(Constant.api_token))!;
    Timer(Duration(milliseconds: 50), () async {
      _fetchBillDetails();
    });
  }
}
