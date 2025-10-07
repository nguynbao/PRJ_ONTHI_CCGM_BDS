import 'package:client_app/config/themes/app_theme.dart';
import 'package:client_app/views/intro_page.dart';
import 'package:client_app/views/opt_page.dart';
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
      home: IntroPage(),
    );
  }
}
