import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rms/utils/Constant.dart';
import 'dart:convert';

import 'package:rms/utils/Utils.dart';

class NoShowData extends StatefulWidget {
  @override
  _NoShowDataState createState() => _NoShowDataState();
}

class _NoShowDataState extends State<NoShowData> {
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> noShowList = [];
  String userId = '';
  String apiToken = '';

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Show Table', style: TextStyle(fontFamily: 'Gilroy', fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.pink,
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
                  _buildNoShowList(),
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
        _fetchNoShowDetails();
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

  Widget _buildNoShowList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: noShowList.length,
      itemBuilder: (context, index) {
        final noShow = noShowList[index];

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
              Text('No Show Details', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
              SizedBox(height: 10),
              _buildDetailRow('Reservation Number', noShow['reservation_number']),
              SizedBox(height: 5),
              _buildDetailRow('Name', '${noShow['first_name']} ${noShow['last_name']}'),
              SizedBox(height: 5),
              _buildDetailRow('Phone Number', noShow['mobile']),
              SizedBox(height: 5),
              _buildDetailRow('Date', noShow['date']),
              SizedBox(height: 5),
              _buildDetailRow('Time', Utils.convertDate(noShow['time'])),
              SizedBox(height: 5),
              _buildDetailRow('Discount', '${noShow['discount']}'),
              SizedBox(height: 5),
              _buildDetailRow('Location', noShow['table_location'] ?? 'NA'),
              SizedBox(height: 5),
              _buildDetailRow('Remark', noShow['no_show_remark'] ?? 'NA'),
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

  Future<void> _fetchNoShowDetails() async {
    final response = await http.post(
      Uri.parse('https://abc.charumindworks.com/inventory/api/v1/noshowrevlist'),
      body: {
        'user_id': userId,
        'apiToken': apiToken,
        'date': dateController.text,
        'status': "",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['noshowrevlistdata'];

      setState(() {
        noShowList = data.map((noShow) => noShow as Map<String, dynamic>).toList();
      });
    } else {
      print('Failed to fetch no show details');
    }
  }


  Future<void> initiate() async {
    userId = (await Utils.getStringFromPrefs(Constant.user_id))!;
    apiToken = (await Utils.getStringFromPrefs(Constant.api_token))!;
    Timer(Duration(milliseconds: 50), () async {
      _fetchNoShowDetails();
    });
  }
}
