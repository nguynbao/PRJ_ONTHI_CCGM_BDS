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
  runApp(const ClientApp());
}

class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Kích thước thiết kế gốc (iPhone 14-like)
      minTextAdapt: true, // Scale text mượt mà dựa trên font scale
      splitScreenMode: true, // Hỗ trợ tablet/multiple windows
      useInheritedMediaQuery: true, // Kế thừa MediaQuery tốt hơn cho responsive
      builder: (context, child) {
        return MaterialApp(
          title: 'Client App', // Thêm title cho app
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          // Nếu có dark mode: darkTheme: AppTheme.darkTheme,
          home: child, // MainScreen sẽ được wrap tự động
        );
      },
      child: const MainScreen(), // Home mặc định là MainScreen
    );
  }
}