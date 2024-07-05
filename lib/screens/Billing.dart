import 'package:flutter/material.dart';
import 'package:rms/utils/Tint.dart';



class Billing extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Settlement',style: TextStyle(fontFamily: 'Gilroy',fontSize: 20,color: Colors.white),),
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
                  //   Colors.white.withOpacity(0.5),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoBox('Yard', '125'),
                      _buildInfoBox('Total', '125'),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildReservationDetails(),
                  SizedBox(height: 10),
                  _buildBookingDateTime(),
                  SizedBox(height: 10),
                  _buildLocationStatus(),
                  SizedBox(height: 10),
                  _buildWaitingForCheckInButton(),
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
          onPressed: () {
            // Handle search action
          },
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
          _buildDetailRow('Name', 'kuldeep yadav'),
          SizedBox(height: 5),
          _buildDetailRow('Phone Number', '9782713123'),
          SizedBox(height: 5),
          _buildDetailRow('Discount', '25%'),
          SizedBox(height: 5),
          _buildDetailRow('No. of Person', '0000125'),
          SizedBox(height: 5),
          _buildDetailRow('Date Of Time', '02-07-2024 02:35 PM'),
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

  Widget _buildBookingDateTime() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Date Time', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy', fontSize: 16)),
          SizedBox(height: 10),
          _buildDetailRow('Date', '02-07-2024'),
          SizedBox(height: 5),
          _buildDetailRow('Time', '12:05 PM'),
        ],
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Location', 'Yard'),
        ],
      ),
    );
  }

  Widget _buildWaitingForCheckInButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle waiting for check-in action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        ),
        child: Text(
          'Waiting For Check-In',
          style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
        ),
      ),
    );
  }
}
