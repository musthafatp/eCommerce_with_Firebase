import 'dart:developer';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ecommerce_with_firebase/Authentication/number_login.dart';
import 'package:ecommerce_with_firebase/widgets/main_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Google Sign in code
  final GoogleSignIn signIn = GoogleSignIn.instance;
  String? error;
  Future<User?> _handlesignin() async {
    try {
      await signIn.initialize(
        serverClientId:
            "215025848873-cp69bkecdmt09c8bhdhqt1s2j3oemevs.apps.googleusercontent.com",
      );

      final account = await signIn.authenticate();
      if (account == null) {
        setState(
          () => error = 'SignIn was Cancelled.',
        );
        return null;
      }
      final auth = account.authentication;
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
      final UserCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = UserCredential.user;
      return user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        setState(() {
          error = 'SignIn Cancelled by user.';
        });
        return null;
      } else {
        setState(() {
          error = 'Error(${e.code}): ${e.description}';
          log(error.toString());
        });
        return null;
      }
    } catch (e) {
      setState(() {
        error = 'Unexpected Error: $e';
        log(error.toString());
      });
      return null;
    }
  }//end of google signin code

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🛍️ Top image
                Center(
                  child: Image.asset(
                    'assets/images/signin.png',
                    width: double.infinity,
                    height: 250.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 40.h),

                // if user is logged in show profile

                // 📝 Title text
                Text(
                  'Get your groceries\nwith nectar',
                  style: GoogleFonts.poppins(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 25.h),

                // 📱 IntlPhoneField (country code + phone input)
                IntlPhoneField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  dropdownIcon: const Icon(Icons.arrow_drop_down),
                  onChanged: (PhoneNumber phone) {
                    debugPrint(phone.completeNumber);
                  },
                ),

                SizedBox(height: 25.h),

                // 🚀 Get Started button
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NumberLogin(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF53B175),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35.h),

                // 🔹 Divider with text
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'Or connect with social media',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                SizedBox(height: 25.h),

                // 🔵 Google Button
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(//Google sign in navigating code
                    onPressed: () async {
                      User? user = await _handlesignin();
                      if (user != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MainTabView(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not found.')));
                      }
                    },//end of Google sign in navigating code
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Continue with Google',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                // 🔵 Facebook Button (optional, not implemented)
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(//Facebook sign in navigating code
                    onPressed: () async {
                      try {
                        final UserCredential userCredential =
                            await signInWithFacebook();
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainTabView()));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not found.')));
                      }
                    },//end of Facebook sign in navigating code
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'assets/images/facebook.png',
                          height: 22.h,
                          width: 22.w,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Continue with Facebook',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
//Future function code of Facebook sign in navigating code
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
