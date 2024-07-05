import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YardTableStatus extends StatefulWidget {
  @override
  _YardTableStatusState createState() => _YardTableStatusState();
}

class _YardTableStatusState extends State<YardTableStatus> {
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Status'),
        backgroundColor: Colors.pink,
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
                  _buildTableCard('Available', 'Table 101 - ALIBON - 6 Person', null),
                  SizedBox(height: 10),
                  _buildTableCard(
                      'Reserved', 'Table 101 - ALIBON - 6 Person', ReservationDetails(
                    id: '00000125',
                    name: 'Kuldeep Yadav',
                    phoneNumber: '9782713123',
                    time: '02:35 PM - 03:35 PM',
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
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Handle search action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          ),
          child: Text('Search', style: TextStyle(color: Colors.white)),
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

  Widget _buildTableCard(String status, String tableInfo, ReservationDetails? details) {
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
                  // Handle view bookings action
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
