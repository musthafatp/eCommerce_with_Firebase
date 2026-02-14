import 'package:ecommerce_with_firebase/Authentication/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding.png', // replace with your image
              fit: BoxFit.cover,
            ),
          ),

          // Overlay for contrast
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),

          // Bottom content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo or icon
                  Image.asset(
                    'assets/images/nectar.png', // replace with your logo
                    width: 60.w,
                    height: 60.h,
                  ),
                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    'Welcome\nto our store',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Subtitle
                  Text(
                    'Get your groceries in as fast as one hour',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Get Started Button
                  Container(
                    width: 353,
                    height: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xFF53B175),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  SignInPage()),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Color(0xFFFFF9FF),
                          fontSize: 18,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
