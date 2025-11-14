import 'package:client_app/views/main_screen/home/pages/flashcard.dart';
import 'package:client_app/views/main_screen/home/pages/home_page.dart';
import 'package:flutter/material.dart';
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

  final List<Widget> _pages = const [
    HomePage(),
    FlashcardPage(),
    // TuDienBDSPage(), // nếu có thêm page
  ];

  @override
  void initState() {
    super.initState();
    _drawerIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
    return Stack(
      children: [

        // 1️⃣ Drawer luôn ở dưới
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: _drawerWidth,
          child: HomeDrawer(
            displayName: 'Sang',
            loading: false,
            onClose: _toggleDrawer,
            onItemSelected: _onDrawerItemSelected,
          ),
        ),

        // 2️⃣ Tap ngoài drawer để đóng
        if (_drawerOpen)
          Positioned(
            left: _drawerWidth, // CHỈ PHỦ PHẦN BÊN NGOÀI
            top: 0,
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _toggleDrawer,
              behavior: HitTestBehavior.opaque,
            ),
          ),

        // 3️⃣ Trang chính Animated
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
          child: AbsorbPointer(
            absorbing: _drawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_drawerOpen ? 25 : 0),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(_getTitle(_selectedPage)),
                  leading: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _drawerIconController,
                    ),
                    onPressed: _toggleDrawer,
                  ),
                ),
                body: IndexedStack(
                  index: _selectedPage,
                  children: _pages,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}