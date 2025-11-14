import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin liên hệ
              Text(
                "Chào mừng đến với Trung tâm Trợ giúp",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF667EEA),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Tìm câu trả lời cho các câu hỏi thường gặp hoặc liên hệ với bộ phận hỗ trợ của chúng tôi.",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
              ),

              SizedBox(height: 24.h),

              // Danh sách Câu hỏi thường gặp (FAQ)
              Text(
                "Câu hỏi thường gặp (FAQ)",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              _buildFaqItem(
                context, // <<< THÊM context VÀO ĐÂY
                title: "Làm thế nào để tải tài liệu ôn thi về máy?",
                content: "Hiện tại, ứng dụng chỉ cho phép ôn tập trực tuyến để đảm bảo tính cập nhật của nội dung. Bạn cần kết nối Internet để sử dụng.",
              ),
              Divider(height: 0, indent: 16.w, endIndent: 16.w),

              // SỬA LỖI: Cần truyền context vào vị trí đầu tiên
              _buildFaqItem(
                context, // <<< THÊM context VÀO ĐÂY
                title: "Nội dung ôn thi có được cập nhật theo luật mới không?",
                content: "Có. Đội ngũ chúng tôi liên tục theo dõi các thay đổi trong Luật Kinh doanh Bất động sản và các quy định liên quan để cập nhật nội dung nhanh nhất có thể.",
              ),
              Divider(height: 0, indent: 16.w, endIndent: 16.w),

              // SỬA LỖI: Cần truyền context vào vị trí đầu tiên
              _buildFaqItem(
                context, // <<< THÊM context VÀO ĐÂY
                title: "Tôi quên mật khẩu, phải làm sao?",
                content: "Vui lòng sử dụng tính năng 'Quên mật khẩu' trên màn hình đăng nhập hoặc vào mục 'Chỉnh sửa tài khoản' để đặt lại mật khẩu của bạn.",
              ),
              Divider(height: 0, indent: 16.w, endIndent: 16.w),

              SizedBox(height: 30.h),

              // Liên hệ
              Text(
                "Thông tin Liên hệ",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              _buildContactInfo(Icons.email_outlined, "Hỗ trợ qua Email:", "support@diaocviet.com"),
              _buildContactInfo(Icons.phone_outlined, "Đường dây nóng:", "1900-1234 (Từ 8h - 17h)"),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm xây dựng mục FAQ (Câu hỏi thường gặp)
  Widget _buildFaqItem(BuildContext context,{required String title, required String content}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        iconColor: const Color(0xFF667EEA),
        collapsedIconColor: Colors.grey.shade600,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 10.w, bottom: 10.h),
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
    );
  }

  // Hàm xây dựng thông tin liên hệ
  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF667EEA), size: 24.sp),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF667EEA),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}