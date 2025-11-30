import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/inside_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Thêm imports cần thiết
import 'package:client_app/controllers/exam.controller.dart';
import 'package:client_app/models/exam.model.dart';


class DetailExamPage extends StatefulWidget { // ✅ CHUYỂN SANG StatefulWidget
  final String examId;
  final String courseId;
  final String examName; // Có thể giữ lại hoặc bỏ, nhưng ta sẽ dùng dữ liệu thật

  const DetailExamPage({super.key, required this.examId, required this.examName, required this.courseId});

  @override
  State<DetailExamPage> createState() => _DetailExamPageState();
}

class _DetailExamPageState extends State<DetailExamPage> { // ✅ TẠO STATE CLASS

  final ExamController _examController = ExamController();
  late Future<Exam?> _examDetailsFuture;

  @override
  void initState() {
    super.initState();
    // Tải chi tiết bài thi khi widget khởi tạo
    _examDetailsFuture = _examController.getExamDetails(
      courseId: widget.courseId,
      examId: widget.examId,
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Exam?>(
      future: _examDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColor.buttonprimaryCol)),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text("Lỗi tải chi tiết bài thi.")),
          );
        }

        // Dữ liệu bài thi đã tải
        final Exam exam = snapshot.data!;

        // Tính toán số câu hỏi
        final int totalQuestions = exam.questions.length;
        final int duration = exam.durationMinutes;

        // --- GIAO DIỆN BÊN TRONG ---
        return Scaffold(
          backgroundColor: const Color(0xffD9D9D9),
          appBar: AppBar(
            toolbarHeight: 80,
            title: Row(
              children: [
                const Spacer(),
                Text(
                  exam.name, // ✅ DÙNG TÊN BÀI THI THẬT
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              box(
                                AppIcons.imgBook,
                                totalQuestions.toString(), // ✅ SỐ CÂU HỎI THẬT
                                'Câu hỏi',
                                AppColor.buttonprimaryCol,
                              ),
                              box(
                                AppIcons.imgTime,
                                _formatTime(duration), // ✅ THỜI GIAN THẬT
                                'Thời gian',
                                AppColor.buttomThirdCol,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Container(
                            height: 300,
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
                                  'Ngày tạo',
                                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', // ✅ Dùng ngày hiện tại
                                  AppColor.buttonprimaryCol,
                                ),
                                item(
                                  AppIcons.imgLich,
                                  'Chủ đề',
                                  exam.name, // ✅ DÙNG ID KHÓA HỌC (hoặc tên nếu có)
                                  AppColor.buttomSecondCol,
                                ),
                                item(
                                  AppIcons.imgStar,
                                  'Đánh giá',
                                  '',
                                  AppColor.buttomThirdCol,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
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
                            child: item(
                              AppIcons.imgReview,
                              'Lịch sử làm bài',
                              'Xem lại kết quả trước',
                              AppColor.purple,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: ElevatedButton(

                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> InsideExamPage(
                      courseId: widget.courseId,
                      examId: widget.examId,
                    ))),
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(AppIcons.imgStart, width: 40, height: 40),
                            Text(
                              "Bắt đầu làm bài kiểm tra",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white, // ✅ THÊM MÀU CHỮ
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget box(icon, String num, String title, Color color) {
    return Container(
      height: 150,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
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
                // width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
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
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(icon, height: 40.h, width: 40.w),
          ),
          SizedBox(width: 15.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
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
