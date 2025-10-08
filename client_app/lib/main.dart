import 'package:client_app/config/themes/app_theme.dart';
import 'package:client_app/views/create_new_password_page.dart';
import 'package:client_app/views/create_pin_page.dart';
import 'package:client_app/views/fill_profile_page.dart';
import 'package:client_app/views/forgot_password_page.dart';
import 'package:client_app/views/intro_page.dart';
import 'package:client_app/views/opt_page.dart';
import 'package:client_app/views/signin_page.dart';
import 'package:client_app/views/signup_page.dart';
import 'package:client_app/views/splash_page.dart';
import 'package:client_app/views/terms_condition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ClientApp());
}

class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: CreateNewPasswordPage(),
    );
  }
}
