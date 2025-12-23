import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/themes/app_color.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trung tâm Trợ giúp",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textpriCol,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: AppColor.textpriCol,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey.shade600),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildWelcomeCard(),
                SizedBox(height: 24.h),
                _buildSectionHeader("Câu hỏi thường gặp"),
                SizedBox(height: 16.h),
                _buildFaqList(),
                SizedBox(height: 32.h),
                _buildSectionHeader("Thông tin Liên hệ"),
                SizedBox(height: 16.h),
                _buildContactCard(),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: AppColor.primaryBlue,
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "Chào mừng đến với Trung tâm Trợ giúp",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "Tìm câu trả lời cho các câu hỏi thường gặp hoặc liên hệ với bộ phận hỗ trợ của chúng tôi.",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColor.primaryBlue,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textpriCol,
          ),
        ),
      ],
    );
  }

  Widget _buildFaqList() {
    final faqs = [
      {
        "title": "Làm thế nào để tải tài liệu ôn thi về máy?",
        "content": "Hiện tại, ứng dụng chỉ cho phép ôn tập trực tuyến để đảm bảo tính cập nhật của nội dung.",
      },
      {
        "title": "Nội dung ôn thi có được cập nhật không?",
        "content": "Có. Đội ngũ chúng tôi liên tục theo dõi các thay đổi trong Luật Kinh doanh Bất động sản mới nhất.",
      },
      {
        "title": "Tôi quên mật khẩu, phải làm sao?",
        "content": "Vui lòng sử dụng tính năng 'Quên mật khẩu' trên màn hình đăng nhập.",
      },
    ];

    return Column(
      children: faqs.map((faq) => _buildFaqItem(
        title: faq["title"]!,
        content: faq["content"]!,
      )).toList(),
    );
  }

  Widget _buildFaqItem({required String title, required String content}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Theme(
        // Cấu hình Theme tại đây để xóa hiệu ứng xám khi click (InkWell effect)
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Icon(
            Icons.question_mark_outlined,
            color: AppColor.primaryBlue,
            size: 24.sp,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textpriCol,
            ),
          ),
          iconColor: AppColor.primaryBlue,
          collapsedIconColor: Colors.grey.shade600,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 56.w, right: 16.w, bottom: 16.h),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    final contacts = [
      {
        "icon": Icons.email_outlined,
        "label": "Hỗ trợ qua Email",
        "value": "support@diaocviet.com",
      },
      {
        "icon": Icons.phone_outlined,
        "label": "Đường dây nóng",
        "value": "1900-1234 (Từ 8h - 17h)",
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: contacts.map((contact) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildContactInfo(
              icon: contact["icon"] as IconData,
              label: contact["label"] as String,
              value: contact["value"] as String,
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColor.primaryBlue, size: 24.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textpriCol,
                ),
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {},
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none, // Bỏ gạch chân
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