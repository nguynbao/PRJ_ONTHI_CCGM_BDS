import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/data/remote/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widget/home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // ✅ Đã thêm lại dữ liệu tĩnh bị thiếu
  static const categories = <String>[
    'Flutter',
    'Dart',
    'State',
    'API',
    'Firebase',
    'UI/UX',
    'Widgets',
    'Testing',
    'Networking',
    'Security',
    'Design',
  ];
  static const lesson = <String>[
    'Flutter Cơ Bản',
    'Dart OOP & Collections',
    'State Management (Provider)',
    'REST API & JSON',
    'Navigation 2.0',
    'Firebase Auth',
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedIndexLesson = 0;
  final _userSvc = UserService();
  String _displayName = '';
  bool _loading = true;

  late AnimationController _drawerIconController;
  bool _drawerOpen = false;
  double _drawerWidth = 0;

  @override
  void initState() {
    super.initState();
    _load();
    _drawerIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..drive(CurveTween(curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _drawerIconController.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _drawerWidth = MediaQuery.of(context).size.width * 0.75;
  }

  Future<void> _load() async {
    try {
      final name = await _userSvc.getDisplayName();
      if (!mounted) return;
      setState(() {
        final parts = (name ?? '').trim().split(' ');
        _displayName = parts.isNotEmpty ? parts.first : 'User';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không lấy được tên: $e')));
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

  void _onDrawerItemSelected(DrawerItem item) {
    _toggleDrawer();
    // ✅ Logic xử lý cho từng item
    switch (item) {
      case DrawerItem.dictionary:
        print('Navigating to Dictionary');
        break;
      case DrawerItem.flashcard:
        print('Navigating to Flashcard');
        break;
      case DrawerItem.logout:
        print('Logging out...');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Điều chỉnh độ rộng Drawer: 75% màn hình
    _drawerWidth = MediaQuery.of(context).size.width * 0.75;

    final title = _loading ? 'Hi, ...' : 'Hi, $_displayName';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // --- 1. Drawer (Luôn nằm dưới) ---
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: _drawerWidth,
              child: HomeDrawer(
                displayName: _displayName,
                loading: _loading,
                onClose: _toggleDrawer,
                onItemSelected: _onDrawerItemSelected,
              ),
            ),

            // --- 2. Main Content (AnimatedContainer trượt) ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // Trượt sang phải (độ rộng drawer - 40.w để lộ góc) và thu nhỏ
              transform: Matrix4.translationValues(
                _drawerOpen ? _drawerWidth - 40.w : 0,
                0,
                0,
              )..scale(_drawerOpen ? 0.9 : 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_drawerOpen ? 25.r : 0),
                boxShadow: [
                  if (_drawerOpen)
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(-5, 5), // Shadow nổi bật hơn
                    ),
                ],
              ),
              child: AbsorbPointer(
                absorbing: _drawerOpen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_drawerOpen ? 25.r : 0),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: _buildAppBar(title),
                    body: _buildBody(),
                  ),
                ),
              ),
            ),

            // --- 3. Icon Menu / X (Luôn nằm trên cùng) ---
            // --- 3. Icon Menu / X (Luôn nằm trên cùng) ---
            Positioned(
              top: MediaQuery.of(context).padding.top + 10.h,
              left: 10.w,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // nền trắng mờ
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 26.h,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _drawerIconController,
                      color: Colors.black,
                    ),
                    onPressed: _toggleDrawer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100.h,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        // Cần padding đủ lớn để tránh đè lên Icon Menu/X
        padding: EdgeInsets.only(left: 60.w),
        child: Row(
          children: [
            // Avatar người dùng
            CircleAvatar(
              radius: 22.r,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
            SizedBox(width: 10.w),
            // Title text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text('Hôm nay học gì nào?',
                    style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureBanner(),
              SizedBox(height: 25.h),
              _buildCategoriesSection(), // ✅ Đã khôi phục
              SizedBox(height: 25.h),
              _buildLessonSection(), // ✅ Đã khôi phục
              SizedBox(height: 25.h),
              _buildFeaturedCourse(), // ✅ Đã khôi phục
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Sections Khôi Phục ---

  Widget _buildSectionHeader({
    required String title,
    VoidCallback? onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            'See All',
            style: TextStyle(color: AppColor.buttonprimaryCol, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "Categories", onSeeAll: () {}),
        SizedBox(height: 15.h),
        SizedBox(
          height: 35.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: HomePage.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final selected = i == _selectedIndex;
              return ChoiceChip(
                label: Text(HomePage.categories[i]),
                selected: selected,
                onSelected: (val) => setState(() => _selectedIndex = i),
                selectedColor: AppColor.buttonprimaryCol.withOpacity(0.9),
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14.sp,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "Lessons", onSeeAll: () {}),
        SizedBox(height: 15.h),
        SizedBox(
          height: 35.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: HomePage.lesson.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final selected = i == _selectedIndexLesson;
              return ChoiceChip(
                label: Text(HomePage.lesson[i]),
                selected: selected,
                onSelected: (val) => setState(() => _selectedIndexLesson = i),
                selectedColor: AppColor.buttomSecondCol.withOpacity(0.9),
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14.sp,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCourse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Featured Course",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: SizedBox(
            height: 250.h,
            width: 250.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/250x150'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Khoa hoc so 2',
                              style: TextStyle(
                                color: AppColor.buttonprimaryCol,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => {},
                              icon: SvgPicture.asset(
                                AppVector.iconTag,
                                height: 18.h,
                                width: 18.w,
                                colorFilter: ColorFilter.mode(
                                  AppColor.buttomThirdCol,
                                  BlendMode.srcIn,
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        Text(
                          "Topic so 1: Xây dựng App E-commerce bằng Flutter",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureBanner() => Container(
    height: 160.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColor.buttonprimaryCol,
      borderRadius: BorderRadius.all(Radius.circular(15.r)),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
    ),
    child: Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: Opacity(
            opacity: 0.2,
            child: SvgPicture.asset(AppVector.iconTag,
                height: 100.h,
                colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Khóa học ưu đãi hôm nay!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w300)),
              SizedBox(height: 8.h),
              Text('Flutter Developer Pro\nGiảm 50%',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttomSecondCol,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r))),
                child: Text('Xem ngay',
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}