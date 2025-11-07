import 'package:client_app/config/themes/app_theme.dart';
import 'package:client_app/views/intro/signup_page.dart';
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:client_app/views/intro/create_new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(ClientApp());
}

class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Kích thước thiết kế gốc
      minTextAdapt: true, // scale text mềm mại
      splitScreenMode: true, // hỗ trợ đa cửa sổ/tablet
      builder: (context, child) {
        return MaterialApp(
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: const MainScreen(),
    );
  }
}
