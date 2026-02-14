import 'package:ecommerce_with_firebase/Authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String? selectedZone = "Banasree";
  String? selectedArea;

  final List<String> zones = ['Banasree', 'Dhanmondi', 'Uttara', 'Gulshan'];
  final List<String> areas = ['Type A', 'Type B', 'Type C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Back Arrow
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black87),
              ),
              SizedBox(height: 24.h),

              // Image Section
              Center(
                child: Image.asset(
                  "assets/images/location_map.png", // replace with your image
                  height: 180.h,
                  width: 180.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 30.h),

              // Title
              Center(
                child: Text(
                  "Select Your Location",
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 8.h),

              // Subtitle
              Center(
                child: Text(
                  "Switch on your location to stay in tune with\nwhat’s happening in your area",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 100.h),

              // Zone Dropdown
              Text(
                "Your Zone",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                value: selectedZone,
                items: zones
                    .map((zone) => DropdownMenuItem(
                          value: zone,
                          child: Text(zone,
                              style: GoogleFonts.poppins(fontSize: 15.sp)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedZone = value),
              ),
              SizedBox(height: 24.h),

              // Area Dropdown
              Text(
                "Your Area",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                hint: Text(
                  "Types of your area",
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.grey[600],
                  ),
                ),
                value: selectedArea,
                items: areas
                    .map((area) => DropdownMenuItem(
                          value: area,
                          child: Text(area,
                              style: GoogleFonts.poppins(fontSize: 15.sp)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedArea = value),
              ),
              SizedBox(height: 50.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53B175),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) =>  LoginPage()));
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
