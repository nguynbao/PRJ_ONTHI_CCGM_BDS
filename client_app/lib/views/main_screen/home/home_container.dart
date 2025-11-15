import 'package:animations/animations.dart';
import 'package:client_app/views/main_screen/home/pages/flashcard.dart';
import 'package:client_app/views/main_screen/home/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../../../data/remote/user_service.dart';
import '../../../widget/home_drawer.dart';

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

  // !!! CHUYỂN LOGIC USER DATA LÊN ĐÂY
  final _userSvc = UserService();
  String _displayName = 'User'; // Giá trị mặc định
  bool _loading = true; // Bắt đầu ở trạng thái loading

  // !!! CẬP NHẬT _pages để truyền data vào HomePage
  // Danh sách này không thể là const nữa vì HomePage cần params
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _drawerIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Bắt đầu tải dữ liệu người dùng
    _load();

    // Khởi tạo _pages sau khi có logic load data
    _pages = [
      // Truyền data vào HomePage đã sửa đổi
      HomePage(displayName: _displayName, loading: _loading),
      const FlashcardPage(),
      // const TuDienBDSPage(),
    ];
  }

  // !!! CHUYỂN HÀM _load() TỪ HOMEPAGE LÊN ĐÂY
  Future<void> _load() async {
    try {
      final name = await _userSvc.getDisplayName();
      if (!mounted) return;
      setState(() {
        final parts = (name ?? '').trim().split(' ');
        _displayName = parts.isNotEmpty ? parts.first : 'User';
        _loading = false;

        // Cập nhật lại _pages sau khi data thay đổi
        _pages[0] = HomePage(displayName: _displayName, loading: _loading);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        // Cập nhật lại _pages sau khi data thay đổi
        _pages[0] = HomePage(displayName: _displayName, loading: _loading);
      });
      // Hiển thị SnackBar (nếu muốn, cần bọc HomeContainer trong MaterialApp)
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không lấy được tên: $e')));
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

  // --- HÀM APPBAR CHO HOMEPAGE (Giữ nguyên) ---
  PreferredSizeWidget _buildHomeAppBar(
      String displayName, AnimationController drawerIconController, bool loading) {
    // ... (Code Home AppBar giữ nguyên)
    final title = loading ? 'Hi, ...' : 'Hi, $displayName';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80.0,
      titleSpacing: 20.0,
      leading: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: drawerIconController,
          color: Colors.black87,
        ),
        onPressed: _toggleDrawer,
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 22.0,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4.0),
              const Text('Hôm nay học gì nào?',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }

  // --- HÀM APPBAR CHO FLASHCARDPAGE (Giữ nguyên) ---
  PreferredSizeWidget _buildFlashcardAppBar(BuildContext context) {
    // ... (Code Flashcard AppBar giữ nguyên)
    final flashcardActions = <Widget>[
      IconButton(
        icon: const Icon(Icons.bar_chart_rounded, color: Colors.black87),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.black87),
        onPressed: () {},
      ),
      const SizedBox(width: 8),
    ];

    final flashcardTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flashcard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'Ôn thi chứng chỉ hành nghề BĐS',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16.0,
      title: flashcardTitle,
      actions: flashcardActions,
      leading: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _drawerIconController,
          color: Colors.black87,
        ),
        onPressed: _toggleDrawer,
      ),
      toolbarHeight: 80.0,
    );
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
    // Khi data loading, có thể hiển thị một màn hình loading hoặc sử dụng dữ liệu mặc định/giả định
    // if (_loading) return const Center(child: CircularProgressIndicator()); // Tùy chọn

    return Stack(
      children: [
        // 1️⃣ Drawer luôn ở dưới
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: _drawerWidth,
          child: HomeDrawer(
            displayName: _displayName, // Dùng _displayName đã load
            loading: _loading, // Dùng _loading đã load
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
                    // !!! CẬP NHẬT LOGIC SỬ DỤNG APPBAR TÙY CHỈNH
                    appBar: _selectedPage == 0
                        ? _buildHomeAppBar(_displayName, _drawerIconController, _loading) // Dùng Home AppBar
                        : _selectedPage == 1
                        ? _buildFlashcardAppBar(context) // Dùng Flashcard AppBar
                        : AppBar( // Dùng AppBar mặc định cho các trang khác
                      title: Text(_getTitle(_selectedPage)),
                      leading: IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _drawerIconController,
                        ),
                        onPressed: _toggleDrawer,
                      ),
                    ),
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
        )
      ],
    );
  }
}