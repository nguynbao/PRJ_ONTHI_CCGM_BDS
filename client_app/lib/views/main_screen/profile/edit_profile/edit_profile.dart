import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Bao Nguyen');
  final _nicknameController = TextEditingController(text: 'Bảo');
  final _birthdateController = TextEditingController(text: '01/01/1990');
  final _emailController = TextEditingController(text: 'bao.nguyen@gmail.com');
  final _phoneController = TextEditingController(text: '+84 123 456 789');
  final _genderController = TextEditingController(text: 'Nam');
  final _occupationController = TextEditingController(text: 'Developer');

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _birthdateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Nền xám nhạt hơn để tạo độ sâu
      appBar: PlatformAppBar(
        title: const Text(
          'Chỉnh sửa Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.05),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: Colors.white,
          leading: CupertinoNavigationBarBackButton(
            color: const Color(0xFF64748B),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---- Avatar ----
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.primaryBlue.withOpacity(0.1),
                                  AppColor.primaryBlue.withOpacity(0.05),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 55.r,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 50.r,
                                backgroundColor:
                                AppColor.primaryBlue.withOpacity(0.1),
                                child: const Text(
                                  'B',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColor.primaryBlue,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Chọn ảnh đại diện',
                        style: TextStyle(
                          color: AppColor.primaryBlue,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                // ---- Form Fields ----
                _buildCustomTextField(
                  controller: _nameController,
                  hintText: 'Họ và Tên đầy đủ',
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                  v?.isEmpty ?? true ? 'Vui lòng nhập họ tên' : null,
                ),
                SizedBox(height: 16.h),
                _buildCustomTextField(
                  controller: _nicknameController,
                  hintText: 'Biệt danh',
                  prefixIcon: Icons.alternate_email_outlined,
                ),
                SizedBox(height: 16.h),
                _buildCustomTextField(
                  controller: _birthdateController,
                  hintText: 'Ngày sinh',
                  prefixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: Icons.arrow_drop_down,
                ),
                SizedBox(height: 16.h),
                _buildCustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                _buildCustomTextField(
                  controller: _phoneController,
                  hintText: 'Số điện thoại',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                _buildCustomTextField(
                  controller: _genderController,
                  hintText: 'Giới tính',
                  prefixIcon: Icons.wc_outlined,
                  readOnly: true,
                  onTap: _showGenderBottomSheet,
                  suffixIcon: Icons.arrow_drop_down,
                ),
                SizedBox(height: 16.h),
                _buildCustomTextField(
                  controller: _occupationController,
                  hintText: 'Nghề nghiệp',
                  prefixIcon: Icons.work_outline,
                  readOnly: true,
                  onTap: _showOccupationBottomSheet,
                  suffixIcon: Icons.arrow_drop_down,
                ),
                SizedBox(height: 40.h),

                // ✅ FIXED BUTTON — chỉ validate khi nhấn
                PlatformWidget(
                  material: (_, __) => SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 4,
                        shadowColor: AppColor.primaryBlue.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Cập nhật',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const Icon(Icons.check, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoButton(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColor.primaryBlue,
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h, horizontal: 40.w),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cập nhật',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(CupertinoIcons.check_mark,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Giữ trắng cho input để nổi bật trên nền xám nhạt
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Color(0xFF1E293B), fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 16.w,
              top: 20.h,
              bottom: 20.h,
            ),
            child: Icon(
              prefixIcon,
              color: AppColor.primaryBlue.withOpacity(0.6),
              size: 20,
            ),
          )
              : null,
          suffixIcon: suffixIcon != null
              ? Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 20.w,
              top: 20.h,
              bottom: 20.h,
            ),
            child: Icon(
              suffixIcon,
              color: AppColor.primaryBlue.withOpacity(0.6),
              size: 20,
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: AppColor.primaryBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 20.h,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900),
                  onDateTimeChanged: (val) {
                    setState(() {
                      _birthdateController.text =
                      '${val.day}/${val.month}/${val.year}';
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Xong'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      );
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            const ColorScheme.light(primary: AppColor.primaryBlue),
          ),
          child: child!,
        ),
      );
      if (date != null) {
        setState(() {
          _birthdateController.text =
          '${date.day}/${date.month}/${date.year}';
        });
      }
    }
  }

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContainer([
        {'label': 'Nam', 'icon': Icons.male},
        {'label': 'Nữ', 'icon': Icons.female},
        {'label': 'Khác', 'icon': Icons.transgender},
      ], (label) => _genderController.text = label),
    );
  }

  void _showOccupationBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContainer([
        {'label': 'Developer', 'icon': Icons.code},
        {'label': 'Designer', 'icon': Icons.design_services},
        {'label': 'Manager', 'icon': Icons.business},
        {'label': 'Student', 'icon': Icons.school},
        {'label': 'Other', 'icon': Icons.more_horiz},
      ], (label) => _occupationController.text = label),
    );
  }

  Widget _buildBottomSheetContainer(
      List<Map<String, dynamic>> items, Function(String) onSelect) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            ...items.map((item) => _buildBottomSheetTile(
              item['label'],
              item['icon'],
                  () {
                setState(() => onSelect(item['label']));
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetTile(String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      leading: Icon(icon, color: AppColor.primaryBlue, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      tileColor: Colors.transparent,
    );
  }

  void _updateProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cập nhật thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
    Navigator.pop(context);
  }
}