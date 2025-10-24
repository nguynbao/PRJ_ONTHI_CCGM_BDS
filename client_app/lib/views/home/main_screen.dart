// lib/presentation/view/main_screen.dart
import 'package:client_app/views/home/home_pages/home_page.dart';
import 'package:flutter/material.dart';

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
    // const ServicesPage(key: PageStorageKey('ServicesPage')),
    // const ProfilePage(key: PageStorageKey('ProfilePage')),
  ];

  // Thông tin tab (tiêu đề, icon)
  final List<_TabInfo> _tabs = const [
    _TabInfo(title: 'Trang chủ', icon: Icons.home_outlined, activeIcon: Icons.home),
    _TabInfo(title: 'Dịch vụ', icon: Icons.design_services_outlined, activeIcon: Icons.design_services),
    _TabInfo(title: 'Tài khoản', icon: Icons.person_outline, activeIcon: Icons.person),
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
          appBar: AppBar(
            title: Text(_title),
            centerTitle: true,
          ),
          body: PageStorage(
            bucket: _bucket,
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: List.generate(_tabs.length, (i) {
              final t = _tabs[i];
              return BottomNavigationBarItem(
                icon: Icon(t.icon),
                activeIcon: Icon(t.activeIcon),
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
  final IconData icon;
  final IconData activeIcon;
  const _TabInfo({
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}
