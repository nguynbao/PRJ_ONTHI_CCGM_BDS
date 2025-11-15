import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  final String displayName;
  final bool loading;

  const HomePage({
    super.key,
    required this.displayName,
    required this.loading,
  });

  static const categories = <String>[
    'Luật BĐS',
    'Môi giới',
    'Hợp đồng',
    'Tài chính',
    'Định giá',
    'Quy hoạch',
    'Thị trường',
    'Phân tích',
  ];

  static const lesson = <String>[
    'Bộ đề trắc nghiệm cơ bản',
    'Pháp luật đất đai nâng cao',
    'Kỹ năng đàm phán Hợp đồng',
    'Quy trình giao dịch BĐS',
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedIndexLesson = 0;

  @override
  Widget build(BuildContext context) {
    // Đảm bảo body là widget cha duy nhất, được bọc bởi SingleChildScrollView trong body.
    return _buildBody();
  }

  Widget _buildBody() {
    return SingleChildScrollView( // Quan trọng: Đã loại bỏ SafeArea thừa nếu HomeContainer đã có
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner (Thi thử)
            _buildFeatureBanner(),
            SizedBox(height: 30.h),

            // Chuyên mục ôn thi (Duy trì cuộn ngang)
            _buildCategoriesSection(),
            SizedBox(height: 30.h),

            // Luyện tập Flashcard (Duy trì cuộn ngang)
            _buildPracticeSection(),
            SizedBox(height: 30.h),

            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CHUNG ---
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
            'Xem tất cả',
            style: TextStyle(color: AppColor.buttonprimaryCol, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  // --- 1. BANNER THI THỬ (HIỆN ĐẠI HƠN) ---
  Widget _buildFeatureBanner() => Container(
    height: 180.h, // Tăng nhẹ chiều cao
    width: double.infinity,
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      // SỬ DỤNG GRADIENT TẠO CẢM GIÁC HIỆN ĐẠI
      gradient: LinearGradient(
        colors: [AppColor.buttonprimaryCol.withOpacity(1.0), AppColor.buttonprimaryCol.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20.r)), // Bo góc lớn hơn
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
    ),
    child: Stack(
      children: [
        // Icon trang trí lớn, mờ
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.assessment_rounded,
            color: Colors.white.withOpacity(0.1),
            size: 130.h,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text('Thi thử chứng chỉ\nMôi giới BĐS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp, // Tăng kích thước tiêu đề chính
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.flash_on, size: 18, color: Colors.white),
              label: Text('Bắt đầu Thi',
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttomSecondCol,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                elevation: 5,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // --- 2. CHUYÊN MỤC VÀ LUYỆN TẬP (GIỮ NGUYÊN) ---
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "Khóa học", onSeeAll: () {}),
        SizedBox(height: 15.h),
        SizedBox(
          height: 45.h, // Tăng nhẹ chiều cao ChoiceChip để nhìn đẹp hơn
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
                // Loại bỏ padding cố định để chip tự co giãn
                // padding: EdgeInsets.symmetric(horizontal: 10.w),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "Luyện tập Flashcard", onSeeAll: () {}),
        SizedBox(height: 15.h),
        SizedBox(
          height: 45.h, // Tăng nhẹ chiều cao
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
                // Loại bỏ padding cố định để chip tự co giãn
              );
            },
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 250.h, // Giữ nguyên chiều cao để ListView có thể cuộn ngang
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4, // Chỉ hiển thị 4 mẫu
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            itemBuilder: (context, index) {
              return _buildCourseCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(int index) {
    return Container(
      width: 200.w, // Giảm chiều rộng một chút để có thể xem 1.5 thẻ
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            child: Image.network(
              'https://via.placeholder.com/200x100?text=Legal+Docs', // Thay đổi placeholder
              height: 100.h,
              width: 200.w,
              fit: BoxFit.cover,
            ),
          ),
          // Nội dung
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index % 2 == 0 ? 'Pháp lý mới' : 'Kinh nghiệm',
                  style: TextStyle(
                    color: AppColor.buttomSecondCol,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  index == 0
                      ? "Cập nhật Nghị định 2024 về Luật Kinh doanh BĐS"
                      : "Hướng dẫn thực hành môi giới BĐS dự án",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: Colors.grey.shade500),
                    SizedBox(width: 4.w),
                    Text('15 phút đọc', style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Giữ nguyên các định nghĩa cho AppColor, AppVector nếu cần thiết.
// Nếu bạn muốn chạy thử, hãy đảm bảo các file config/assets/app_vectors.dart và config/themes/app_color.dart đã được import và định nghĩa.