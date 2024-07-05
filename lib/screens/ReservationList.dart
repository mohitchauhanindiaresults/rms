import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rms/utils/Tint.dart';



class ReservationList extends StatelessWidget {
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController numberOfPersonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation List',style: TextStyle(fontFamily: 'Gilroy',fontSize: 20,color: Colors.white),),
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
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDropdownButton('Select Status'),
                    _buildTextFieldWithIcon(dateController, 'Date', Icons.calendar_today),
                  ],
                ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoBox('Yard', '125'),
                      _buildInfoBox('Alibon', '125'),
                      _buildInfoBox('   Total   ', '125'),
                    ],
                  ),
                  SizedBox(height: 10),

                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                    
                          SizedBox(height: 10),
                          _buildReservationDetails(),
                          SizedBox(height: 10),
                          _buildBookingDateTime(),
                          SizedBox(height: 10),
                          _buildLocationStatus(),
                          SizedBox(height: 10),
                          _buildStatusButtons(context),
                        ],
                      ),
                    ),
                  ),
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
            hintText,
            style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          ),
          dropdownColor: Colors.black,
          items: <String>['Status1', 'Status2', 'Status3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            // Handle dropdown change
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
  Widget _buildStatusButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle waiting for check-in action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
          child: Text(
            'Waiting For Check-In',
            style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle cancel action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
          ),
        ),
      ],
    );
  }



}
