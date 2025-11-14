import 'package:client_app/config/themes/app_theme.dart';
import 'package:client_app/views/intro/signin_page.dart';
import 'package:client_app/views/intro/signup_page.dart';
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:client_app/views/intro/create_new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; 


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  

  await Firebase.initializeApp();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  

  runApp(const ClientApp());
}
class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Client App',
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          home: child, 
        );
      },
      child: const AuthChecker(), 
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        if (snapshot.hasError) {
         
          return const Scaffold(body: Center(child: Text('Đã xảy ra lỗi kết nối.')));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
         
          return const SigninPage();
        } 
        
        else {
          return const SignupPage();
        }
      },
    );
  }
}