import 'package:client_app/views/intro/create_new_password_page.dart';
import 'package:client_app/views/main_screen/profile/edit_profile/edit_profile.dart';
import 'package:client_app/views/main_screen/profile/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../intro/terms_condition_page.dart';
import 'Security/security.dart';
import 'helpcenter/helpcenter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20.r,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header với ảnh đại diện nửa nổi
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF667EEA),
                        const Color(0xFF764BA2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment(0, -0.3),
                    child: Text(
                      "Hồ sơ cá nhân",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Ảnh đại diện nửa trong nửa ngoài
                Positioned(
                  bottom: -50.h,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF667EEA),
                              const Color(0xFF764BA2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          child: Text(
                            'B',
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: Color(0xFF667EEA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF667EEA),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 70.h),

            // Container thông tin người dùng và danh sách chức năng chung
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Thông tin người dùng
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Bao Nguyen',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'bao.nguyen@gmail.com',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Danh sách chức năng
                  Column(
                    children: [
                      _buildProfileTile(
                        Icons.person_outline,
                        'Chỉnh sửa tài khoản',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),
                      _buildProfileTile(
                        Icons.settings_outlined,
                        'Cài đặt',
                        onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingPage(),)
                            );
                        }
                      ),
                      _buildProfileTile(Icons.notifications_none, 'Thông báo'),
                      _buildProfileTile(
                        Icons.security_outlined,
                        'Bảo mật',
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecurityPage(),
                            ),
                          );
                        }
                      ),
                      _buildProfileTile(
                        Icons.language_outlined,
                        'Ngôn ngữ',
                        trailing: 'Tiếng Việt (VN)',
                      ),
                      _buildProfileTile(
                        Icons.remove_red_eye_outlined,
                        'Chế độ tối',
                      ),
                      _buildProfileTile(
                        Icons.receipt_long_outlined,
                        'Điều khoản & Điều kiện',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // SỬA DỤNG TRANG MỚI
                              builder: (context) => const TermsConditionPage(),
                            ),
                          );
                        },
                      ),
                      _buildProfileTile(
                        Icons.help_outline,
                        'Trung tâm Trợ giúp',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // SỬA DỤNG TRANG MỚI
                              builder: (context) => const HelpCenterPage(),
                            ),
                          );
                        },
                      ),
                      _buildProfileTile(Icons.mail_outline, 'Mời bạn bè'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
      IconData icon,
      String title, {
        String? trailing,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        leading: Icon(icon, color: Colors.black87, size: 28.sp),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            SizedBox(width: 12.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
              color: Colors.grey.shade400,
            ),
          ],
        ),
        onTap: onTap,
        dense: false,
        minVerticalPadding: 0,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      ),
    );
  }
}