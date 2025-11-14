import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/auth.controller.dart';
import 'package:client_app/controllers/user.controller.dart';
import 'package:client_app/views/intro/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DrawerItem {
  home,
  flashcard,
  // dictionary,
  logout,
}

class HomeDrawer extends StatefulWidget {
  final bool loading;
  final VoidCallback onClose;
  final Function(DrawerItem) onItemSelected;

  const HomeDrawer({
    super.key,

    required this.loading,
    required this.onClose,
    required this.onItemSelected,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _userCtrl = UserController();
  String _displayName = '';
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });

    final name = await _userCtrl.getDisplayName();

    if (!mounted) return;

    setState(() {
      _displayName = (name ?? 'Guest').trim();
      _loading = false; // 🔥 QUAN TRỌNG: tắt trạng thái loading
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = AuthController();
    final drawerWidth = MediaQuery.of(context).size.width * 0.78;
    void _handleLogout() async {
      try {
        await _authController.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully!')),
        );
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SigninPage()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    }

    return Container(
      width: drawerWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.buttonprimaryCol.withOpacity(0.95),
            Colors.white.withOpacity(0.96),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              SizedBox(height: 70.h),

              // --- Profile nhỏ ---
              Row(
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: AppColor.buttonprimaryCol,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.loading
                          ? 'Hi, ...'
                          : 'Hi, ${_displayName.isEmpty ? "User" : _displayName}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35.h),
              Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8),

              // --- Mục chức năng chính ---
              _buildDrawerItem(
                context,
                icon: Icons.home_rounded,
                title: "Trang chủ",
                subtitle: "Trang chính",
                gradient: [Colors.greenAccent, Colors.teal],
                onTap: () {
                  widget.onItemSelected(DrawerItem.home);
                  // onClose();
                },
              ),

              _buildDrawerItem(
                context,
                icon: Icons.style_rounded,
                title: "Flashcard",
                subtitle: "Ôn tập nhanh",
                gradient: [Colors.lightBlueAccent, Colors.blueAccent],
                onTap: () {
                  widget.onItemSelected(DrawerItem.flashcard);
                  // onClose();
                },
              ),

              // _buildDrawerItem(
              //   context,
              //   icon: Icons.menu_book_rounded,
              //   title: "Từ điển BĐS",
              //   subtitle: "Thuật ngữ quan trọng",
              //   gradient: [Colors.greenAccent, Colors.teal],
              //   onTap: () {
              //     onItemSelected(DrawerItem.dictionary);
              //     // onClose();
              //   },
              // ),
              SizedBox(height: 30.h),
              Divider(color: Colors.black12),

              // --- Thông tin ---
              Text(
                "Thông tin kỳ thi",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: AppColor.buttonprimaryCol,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Lịch thi sắp tới",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Kỳ thi tháng 12/2024",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Đăng ký trước 30/11",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // --- Logout ---
              GestureDetector(
                onTap: () {
                  widget.onItemSelected(DrawerItem.logout);
                  widget.onClose();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: InkWell(
                    onTap: () {
                      debugPrint('$context ,Đã ấn vào');
                      _handleLogout();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 10.w),
                        Text(
                          "Đăng xuất",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 44.w,
                width: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: gradient),
                ),
                child: Icon(icon, color: Colors.white, size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
