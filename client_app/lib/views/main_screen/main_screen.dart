// lib/presentation/view/main_screen.dart
import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/exam_page.dart';
import 'package:client_app/views/main_screen/home/home_page.dart';
import 'package:client_app/views/main_screen/my_courses/my_courses_page.dart';
import 'package:client_app/views/main_screen/notication/notication_page.dart';
import 'package:client_app/views/main_screen/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// TODO: thay bằng import thật trong dự án của bạn
// Ví dụ thêm một tab hồ sơ
// Tạo file profile_page.dart riêng nếu bạn chưa có
// Hoặc tạm dùng Placeholder() ngay trong _pages.

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lưu trạng thái cuộn/scroll từng tab
  final PageStorageBucket _bucket = PageStorageBucket();

  // Danh sách page (fragment)
  late final List<Widget> _pages = <Widget>[
    const HomePage(key: PageStorageKey('HomePage')),
    const MyCoursesPage(key: PageStorageKey('MyCoursesPage'), courses: '..', topic: '..', ),// truyền giá trị thật),
    const ExamPage(key: PageStorageKey('ExamPage')),
    const NoticationPage(key: PageStorageKey('NoticationPage')),
    const ProfilePage(key: PageStorageKey('ProfilePage')),
  ];

  // Thông tin tab (tiêu đề, icon)
  final List<_TabInfo> _tabs = const [
    _TabInfo(title: 'Trang chủ', svgPath: AppVector.iconHome),
    _TabInfo(title: 'Bài học', svgPath: AppVector.iconCourses),
    _TabInfo(title: 'Kiểm tra', svgPath: AppVector.iconExam),
    _TabInfo(title: 'Thông báo', svgPath: AppVector.iconNoti),
    _TabInfo(title: 'Tài khoản', svgPath: AppVector.iconProfile),
  ];

  // Tiêu đề app bar theo tab
  String get _title => _tabs[_currentIndex].title;

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
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: PageStorage(
            bucket: _bucket,
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: _currentIndex,
            selectedItemColor: AppColor.buttomSecondCol,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),

            type: BottomNavigationBarType.fixed,
            items: List.generate(_tabs.length, (i) {
              final t = _tabs[i];
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(t.svgPath, width: 22, height: 22),
                activeIcon: SvgPicture.asset(
                  t.svgPath,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    AppColor.buttomSecondCol,
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
    );
  }
}

class _TabInfo {
  final String title;
  final String svgPath;
  const _TabInfo({required this.title, required this.svgPath});
}
