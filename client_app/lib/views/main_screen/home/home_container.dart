import 'package:animations/animations.dart';
import 'package:client_app/views/main_screen/home/flashcard.dart';
import 'package:client_app/views/main_screen/home/home_page.dart';
import 'package:flutter/material.dart';
import '../../../widget/drawer/home_drawer.dart';

// Định nghĩa typedef cho hàm mở/đóng drawer
typedef ToggleDrawerCallback = void Function();

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> with SingleTickerProviderStateMixin {
  int _selectedPage = 0;
  bool _drawerOpen = false;
  late AnimationController _drawerIconController;
  double _drawerWidth = 0;

  // *** THAY ĐỔI: Bỏ const và khai báo List<Widget> trong initState/build thay vì khai báo hằng
  late List<Widget> _pages; 

  @override
  void initState() {
    super.initState();
    _drawerIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _backToHomePage() {
    if (_selectedPage != 0) {
      // Đổi trang nội bộ, PageTransitionSwitcher sẽ tự chạy animation
      setState(() => _selectedPage = 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _drawerWidth = MediaQuery.of(context).size.width * 0.75;
  }

  @override
  void dispose() {
    _drawerIconController.dispose();
    super.dispose();
  }

  void closeDrawerIfOpen() {
    if (_drawerOpen) {
      // Đặt state và chạy animation đóng
      setState(() {
        _drawerOpen = false;
      });
      _drawerIconController.reverse();
    }
  }

  void _toggleDrawer() {
    setState(() {
      _drawerOpen = !_drawerOpen;
      if (_drawerOpen) {
        _drawerIconController.forward();
      } else {
        _drawerIconController.reverse();
      }
    });
  }

  void _onDrawerItemSelected(DrawerItem item) async {

    // 1️⃣ Đóng Drawer trước
    setState(() => _drawerOpen = false);
    await _drawerIconController.reverse();

    // 2️⃣ Sau khi Drawer đóng xong mới đổi trang
    switch (item) {
      case DrawerItem.home:
        setState(() => _selectedPage = 0);
        break;
      case DrawerItem.flashcard:
        setState(() => _selectedPage = 1);
        break;
      // case DrawerItem.dictionary:
      //   setState(() => _selectedPage = 2);
      //   break;
      case DrawerItem.logout:
        break;
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Trang chủ';
      case 1:
        return 'Flashcard';
      case 2:
        return 'Từ điển BĐS';
      default:
        return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    // *** THAY ĐỔI: Khởi tạo _pages ở đây để truyền hàm _toggleDrawer
    _pages = [
      HomePage(onOpenDrawer: _toggleDrawer, ), // Index 0 (Trang chủ)
      FlashcardPage(onBackToHome: _backToHomePage),
      // TuDienBDSPage(),
    ];

    return Stack(
      children: [

        // 1️⃣ Drawer luôn ở dưới
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: _drawerWidth,
          child: HomeDrawer(
            // displayName: 'Sang',
            loading: false,
            onClose: _toggleDrawer,
            onItemSelected: _onDrawerItemSelected,
          ),
        ),

        // 3️⃣ Trang chính Animated + overlay
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
              _drawerOpen ? _drawerWidth - 40 : 0, 0, 0)
            ..scale(_drawerOpen ? 0.95 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_drawerOpen ? 25 : 0),
            boxShadow: _drawerOpen
                ? [const BoxShadow(color: Colors.black26, blurRadius: 20)]
                : [],
          ),
          child: Stack(
            children: [
              // --- Page chính ---
              AbsorbPointer(
                absorbing: _drawerOpen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_drawerOpen ? 25 : 0),
                  child: Scaffold(
                    body: PageTransitionSwitcher(
                      // Giảm thời gian transition xuống mức hợp lý
                      duration: const Duration(milliseconds: 1000),
                      reverse: false,
                      transitionBuilder: (child, animation, secondaryAnimation) {

                        // --- 1. HIỆU ỨNG TRANG MỚI ĐI VÀO (Entry: dùng 'animation') ---

                        // Hiệu ứng Trượt vào từ trên xuống (giữ nguyên logic của bạn)
                        final entryOffsetAnimation = Tween<Offset>(
                          begin: const Offset(0, -0.1), // Bắt đầu từ trên xuống
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ));

                        // Hiệu ứng Mờ dần (Fade in) cho trang mới
                        final entryFadeAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        );

                        // --- 2. HIỆU ỨNG TRANG CŨ ĐI RA (Exit: dùng 'secondaryAnimation') ---

                        // Hiệu ứng làm mờ trang cũ đi ra
                        // Tween đảo ngược độ mờ: 1.0 (hiện) -> 0.0 (mờ dần)
                        final exitFadeAnimation = Tween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ).animate(CurvedAnimation(
                          parent: secondaryAnimation, // Dùng secondaryAnimation cho trang cũ
                          curve: Curves.easeOut,
                        ));

                        return FadeTransition(
                          // Áp dụng hiệu ứng mờ cho trang cũ đi ra
                          opacity: exitFadeAnimation,
                          child: SlideTransition(
                            // Áp dụng hiệu ứng trượt vào cho trang mới
                            position: entryOffsetAnimation,
                            child: FadeTransition(
                              // Áp dụng hiệu ứng mờ vào cho trang mới (nếu cần thiết, nếu không có thể bỏ)
                              opacity: entryFadeAnimation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(_selectedPage),
                        child: _pages[_selectedPage],
                      ),
                    ),
                  ),
                ),
              ),

              // --- Overlay chỉ xuất hiện khi drawer mở ---
              if (_drawerOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _toggleDrawer,
                    behavior: HitTestBehavior.opaque,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_drawerOpen ? 25 : 0),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

      ],
    );
  }
}