import 'package:ecommerce_with_firebase/Authentication/forget_password.dart';
import 'package:ecommerce_with_firebase/Authentication/signup.dart';
import 'package:ecommerce_with_firebase/Authentication/toast_message.dart';
import 'package:ecommerce_with_firebase/ui/home_screen.dart';
import 'package:ecommerce_with_firebase/widgets/main_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
FirebaseAuth auth = FirebaseAuth.instance;
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
                    "Login to your account",
                    style: GoogleFonts.poppins(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Enter your emails and password",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Email field
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
                  SizedBox(height: 10.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
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
                    auth
                        .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        )
                        .then(
                          (value) => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext) => MainTabView(),
                              ),
                            ),
                          },
                        )
                        .onError(
                          (error, stackTrace) => ToastMessage().toastMessage(
                            message: error.toString(),
                          ),
                        );
                  },
                      child: Text(
                        "Log In",
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
                          "Don’t have an account? ",
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
                                    builder: (context) => const SignUp()));
                          },
                          child: Text(
                            "Signup",
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
