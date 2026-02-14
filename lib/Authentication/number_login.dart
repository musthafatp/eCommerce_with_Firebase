import 'package:ecommerce_with_firebase/Authentication/login.dart';
import 'package:ecommerce_with_firebase/Authentication/number_verification.dart';
import 'package:ecommerce_with_firebase/Authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class NumberLogin extends StatefulWidget {
  const NumberLogin({super.key});

  @override
  State<NumberLogin> createState() => _NumberLoginState();
}

class _NumberLoginState extends State<NumberLogin> with WidgetsBindingObserver {
  final TextEditingController numbercontroller = TextEditingController();
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    numbercontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _keyboardVisible = bottomInset > 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),

            // 📝 Title
            Text(
              'Enter your mobile number',
              style: GoogleFonts.poppins(
                fontSize: 26.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 40.h),

            // 📱 Label
            Text(
              'Mobile Number',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8.h),

            // 📞 IntlPhoneField
            IntlPhoneField(
              controller: numbercontroller,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 16.sp,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF53B175), width: 1.5),
                ),
              ),
              initialCountryCode: 'BD',
              showDropdownIcon: true,
              dropdownIcon: const Icon(Icons.arrow_drop_down),
              keyboardType: TextInputType.number,
              onChanged: (PhoneNumber number) {
                debugPrint(number.completeNumber);
              },
            ),

            SizedBox(height: 20.h),

            // ℹ️ Small tip
            Text(
              'We’ll send you a verification code to this number.',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
              ),
            ),

            const Spacer(), // 👈 pushes below content to bottom

            // 👇 Bottom buttons
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53B175),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  'Have an account? Login',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53B175),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  'Don’t have an account? Sign Up',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),

      // ✅ Floating Action Button
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Keeps FAB above keyboard
          right: 10.w, // Responsive right spacing
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NumberVerification(), // Your next page
              ),
            );
          },
          backgroundColor: const Color(0xFF53B175),
          elevation: 4,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30.sp, // Responsive icon size
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
