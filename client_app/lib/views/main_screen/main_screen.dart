import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/exam_page.dart';
import 'package:client_app/views/main_screen/flash_card/flash_card_page.dart';
import 'package:client_app/views/main_screen/home/home_container.dart';
import 'package:client_app/views/main_screen/home/pages/home_page.dart';
import 'package:client_app/views/main_screen/my_courses/my_courses_page.dart';
import 'package:client_app/views/main_screen/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection(); 
  }

  void _checkFirebaseConnection() {
    try {
      final authInstance = FirebaseAuth.instance;
      print("Firebase Auth instance OK: ${authInstance.currentUser}");
    } catch (e) {
      print("LỖI: Không thể truy cập Firebase Service: $e");
    }
  }

  int _currentIndex = 0;

  // Lưu trạng thái cuộn/scroll từng tab
  final PageStorageBucket _bucket = PageStorageBucket();

  // Danh sách page (fragment)
  late final List<Widget> _pages = <Widget>[
    const HomeContainer(key: PageStorageKey('HomePage')),
    const MyCoursesPage(key: PageStorageKey('MyCoursesPage'), courses: '..', topic: '..', ),// truyền giá trị thật),
    const ExamPage(key: PageStorageKey('ExamPage')),
    const FlashCardPage(key: PageStorageKey('FlashCardPage')),
    const ProfilePage(key: PageStorageKey('ProfilePage')),
  ];

  // Thông tin tab (tiêu đề, icon)
  final List<_TabInfo> _tabs = const [
    _TabInfo(title: 'Trang chủ', svgPath: AppVector.iconHome),
    _TabInfo(title: 'Bài học', svgPath: AppVector.iconCourses),
    _TabInfo(title: 'Kiểm tra', svgPath: AppVector.iconExam),
    _TabInfo(title: 'Ghi nhớ', svgPath: AppVector.icon),
    _TabInfo(title: 'Tài khoản', svgPath: AppVector.iconProfile),
  ];

  // Đóng bàn phím khi đổi tab / chạm nền
  void _dismissKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<bool> _onWillPop() async {
    // Nếu không ở tab đầu, bấm back sẽ đưa về tab đầu
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }
    // Ở tab đầu thì cho pop (thoát màn hình)
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Android: icon đen
        statusBarBrightness: Brightness.light, // iOS: icon đen
      ),
      child: GestureDetector(
        onTap: _dismissKeyboard,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: PageStorage(
              bucket: _bucket,
              child: IndexedStack(index: _currentIndex, children: _pages),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 8,
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFF2196F3),
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: List.generate(_tabs.length, (i) {
                final t = _tabs[i];
                return BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    t.svgPath,
                    width: 24,
                    height: 24,
                    color: Colors.black,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    t.svgPath,
                    width: 24,
                    height: 24,
                    color: Colors.black,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2196F3),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: t.title,
                );
              }),
              onTap: (i) {
                if (i == _currentIndex) return;
                _dismissKeyboard();
                setState(() => _currentIndex = i);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TabInfo {
  final String title;
  final String svgPath;
  const _TabInfo({required this.title, required this.svgPath});
}
