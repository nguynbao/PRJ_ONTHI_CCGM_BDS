import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/review_exam_page.dart';
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalExamPage extends StatelessWidget {
  final String courseId;
  final String examId;
  final String examName;
  final int totalQuestions;
  final int correctAnswers;
  final int durationMinutes;
  final int timeSpentSeconds;
  final Map<String, String?> userAnswers;

  const TotalExamPage({
    super.key,
    required this.courseId,
    required this.examId,
    required this.examName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.durationMinutes,
    required this.timeSpentSeconds,
    required this.userAnswers,
  });

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán điểm số và câu trả lời
    final int wrongAnswers = totalQuestions - correctAnswers;
    final double percentage = totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => {
                // Quay về MainScreen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                      (Route<dynamic> route) => false,
                ),
              },
              icon: Image.asset(AppIcons.imgBack),
            ),
            const Spacer(),
            Text(
              examName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
        backgroundColor: AppColor.buttonprimaryCol,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 10), // Sửa lỗi Padding
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          box(
                            AppIcons.imgBook,
                            totalQuestions.toString(),
                            'Câu hỏi',
                            AppColor.buttonprimaryCol,
                          ),
                          box(
                            AppIcons.imgTime,
                            _formatTime(timeSpentSeconds),
                            'Thời gian',
                            AppColor.buttomThirdCol,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 380.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              spreadRadius: 0,
                              color: Colors.black38,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item(
                              AppIcons.imgLich,
                              'Ngày hoàn thành',
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', // ✅ DÙNG NGÀY HIỆN TẠI
                              AppColor.buttonprimaryCol,
                            ),
                            item(
                              AppIcons.imgLich,
                              'Số câu đúng',
                              '$correctAnswers/$totalQuestions', // ✅ DÙNG DỮ LIỆU THẬT
                              Colors.green.shade400,
                            ),
                            item(
                              AppIcons.imgLich,
                              'Số câu sai',
                              '$wrongAnswers/$totalQuestions', // ✅ DÙNG DỮ LIỆU THẬT
                              Colors.red.shade400,
                            ),
                            SizedBox(height: 15.h),
                            const Divider(thickness: 0.2, indent: 30, endIndent: 30),
                            item(
                              AppIcons.imgStar,
                              'Đánh giá',
                              percentage >= 80 ? 'Hoàn thành Tốt' : 'Cần cải thiện', // ✅ DÙNG TỶ LỆ THẬT
                              AppColor.buttomThirdCol,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // NÚT XEM LẠI BÀI KIỂM TRA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ElevatedButton(
                // ✅ SỬA LOGIC ONPRESSED: TRUYỀN DỮ LIỆU SANG REVIEW PAGE
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReviewExamPage(
                          courseId: courseId,
                          examId: examId,
                          userAnswers: userAnswers, // TRUYỀN KẾT QUẢ ĐÃ LÀM
                        )
                    )
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonprimaryCol,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 5,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.buttonprimaryCol,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Xem lại bài kiểm tra",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget box và item được giữ nguyên để định dạng
  Widget box(icon, String num, String title, Color color) {
    return Container(
      height: 150,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 8),
            color: Colors.black38,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                      color: Colors.black38,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(icon, height: 60, width: 60),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      num,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(icon, String title, String content, Color color) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.w),
      child: Row(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(icon, height: 40, width: 40),
          ),
          SizedBox(width: 15.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.black38,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}