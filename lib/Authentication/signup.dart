import 'package:ecommerce_with_firebase/Authentication/login.dart';
import 'package:ecommerce_with_firebase/Authentication/signin_page.dart';
import 'package:ecommerce_with_firebase/Authentication/toast_message.dart';
import 'package:ecommerce_with_firebase/widgets/main_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carrot Icon
                  Center(
                    child: Image.asset(
                      'assets/images/carrot.png', // Replace with your image path
                      height: 80.h,
                    ),
                  ),
                  SizedBox(height: 60.h),

                  // Title
                  Text(
                    "SignUp",
                    style: GoogleFonts.poppins(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Enter your credentials to continue",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 40.h),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "imshuvo97@gmail.com",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Password field
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),

                  // Forgot Password

                  SizedBox(height: 30.h),

                  // Login Button
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
                        if (passwordController.text == confirmPasswordController.text) {
                      auth
                          .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          )
                          .then(
                            (value) => {
                              ToastMessage().toastMessage(
                                message: 'Successfully registered',
                              ),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainTabView(),
                                ),
                              ),
                            },
                          );
                    } else {
                      ToastMessage().toastMessage(
                        message: "Passwords do not match",
                      );
                    }
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Signup link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: const Color(0xFF53B175),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
