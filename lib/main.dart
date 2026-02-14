import 'package:ecommerce_with_firebase/Authentication/login.dart';
import 'package:ecommerce_with_firebase/firebase_options.dart';
import 'package:ecommerce_with_firebase/ui/explore/bevarages_page.dart';
import 'package:ecommerce_with_firebase/ui/explore/explore_page.dart';
import 'package:ecommerce_with_firebase/ui/home_screen.dart';
import 'package:ecommerce_with_firebase/welcome/splash_screen.dart';
import 'package:ecommerce_with_firebase/widgets/main_tab_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized(); // important
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(415, 897),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
