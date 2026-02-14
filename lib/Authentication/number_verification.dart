import 'package:ecommerce_with_firebase/Authentication/select_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberVerification extends StatelessWidget {
  const NumberVerification({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpcontroller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 30.h),
          Text(
            'Enter Your 4 Digit Code',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 30.h),
          Text('Code',
              style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500)),
          TextFormField(
            controller: otpcontroller,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              counterText: '',
              hintText: '- - - -',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Padding(
    padding: EdgeInsets.only(
      left: 20.w,
      right: 20.w,
      bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
    ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
          'Resend Code',
          style: GoogleFonts.poppins(
            color: const Color(0xFF53B175),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectLocation(), // Your next page
                  ),
                );
              },
              backgroundColor: const Color(0xFF53B175),
          elevation: 4,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 28.sp,
          ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
