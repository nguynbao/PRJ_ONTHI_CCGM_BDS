import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Import Controller và Model
import 'package:client_app/controllers/exam.controller.dart';
import 'package:client_app/widget/modal/show_modal.dart';


class ReviewExamPage extends StatefulWidget {
  final String courseId;
  final String examId;
  final Map<String, String?> userAnswers;

  const ReviewExamPage({
    super.key,
    required this.courseId,
    required this.examId,
    required this.userAnswers,
  });

  @override
  State<ReviewExamPage> createState() => _ReviewExamPageState();
}

class _ReviewExamPageState extends State<ReviewExamPage> {

  final ExamController _examController = ExamController();

  int _currentQuestionIndex = 0;

  late Future<Map<String, dynamic>?> _examQuestionsFuture;
  Map<String, dynamic> _rawQuestionsData = {};
  List<String> _questionKeys = []; // Dùng Key để duyệt câu hỏi theo thứ tự

  @override
  void initState() {
    super.initState();
    _examQuestionsFuture = _examController.getExamQuestions(
      courseId: widget.courseId,
      examId: widget.examId,
    );
  }

  // --- Logic Chuyển Câu ---
  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questionKeys.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _examQuestionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColor.buttonprimaryCol)),
          );
        }

        if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Lỗi tải kết quả bài thi hoặc không tìm thấy câu hỏi.")),
          );
        }

        // --- Xử lý dữ liệu đã tải lần đầu (SẮP XẾP KEY) ---
        if (_questionKeys.isEmpty) {
          _rawQuestionsData = snapshot.data!;
          _questionKeys = _rawQuestionsData.keys.toList();

          _questionKeys.sort((a, b) {
            final RegExp regExp = RegExp(r'Câu\s+(\d+)\s*:');
            final matchA = regExp.firstMatch(a);
            final matchB = regExp.firstMatch(b);

            if (matchA == null || matchB == null) return 0;

            final numA = int.tryParse(matchA.group(1) ?? '0') ?? 0;
            final numB = int.tryParse(matchB.group(1) ?? '0') ?? 0;

            return numA.compareTo(numB);
          });
        }

        return _buildReviewContent(context);
      },
    );
  }

  Widget _buildReviewContent(BuildContext context) {
    if (_questionKeys.isEmpty) return const SizedBox();

    final currentQuestionKey = _questionKeys[_currentQuestionIndex];
    final Map<String, dynamic> firestoreOptionsMap =
        _rawQuestionsData[currentQuestionKey] as Map<String, dynamic>? ?? {};

    // Đáp án người dùng đã chọn cho câu hiện tại (là Key Dài hoặc null)
    final String? selectedFullKey = widget.userAnswers[currentQuestionKey];

    // Tìm Đáp án Đúng (Key Dài có value là true)
    final String correctFullKey = firestoreOptionsMap.keys.firstWhere(
        (key) => firestoreOptionsMap[key] == true,
      orElse: () => '', // Trả về rỗng nếu không có đáp án đúng
    );

    final String questionExplanaion = (firestoreOptionsMap['explanation'] as String?)
      ?? "Không có giải thích chi tiết cho câu hỏi này.";

    // Danh sách các Key Dài của đáp án để hiển thị
    final List<String> optionFullKeys = firestoreOptionsMap.keys
      .cast<String>()
      .where((key) => key != 'explanation')
      .toList()
      ..sort();


    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            IconButton(
              onPressed: () => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                      (Route<dynamic> route) => false,
                ),
              },
              icon: Image.asset(AppIcons.imgBack),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Xem kết quả",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                showExplanationModal(
                  context,
                  questionExplanaion
                );
              }, child: Image.asset(AppIcons.imgCheck)),
          ],
        ),
        backgroundColor: AppColor.buttonprimaryCol,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Câu số ${_currentQuestionIndex + 1}:",
                        style: const TextStyle(
                          color: AppColor.primaryBlue,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 20),
                      // KHUNG NỘI DUNG CÂU HỎI
                      Container(
                        constraints: BoxConstraints(minHeight: 150.h),
                        width: double.infinity,
                        padding: EdgeInsets.all(20.h),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black38,
                              offset: Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border(
                            left: BorderSide(
                              color: AppColor.buttonprimaryCol,
                              width: 6,
                            ),
                          ),
                        ),
                        child: Text(
                          currentQuestionKey,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                      SizedBox(height: 20),

                      // HIỂN THỊ KẾT QUẢ CỦA CÁC ĐÁP ÁN
                      ...optionFullKeys.map((fullKey) {
                        // fullKey lúc này là "A. Tính pháp lý"

                        // Tạm thời hiển thị toàn bộ Key Dài
                        final String answerContent = fullKey;

                        return _buildReviewAnswerBox(
                          fullKey: fullKey, // Truyền Key Dài làm giá trị so sánh
                          answer: answerContent,
                          selectedFullKey: selectedFullKey, // Key Dài đã chọn
                          correctFullKey: correctFullKey,   // Key Dài đáp án đúng
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Nút Lùi
              Container(
                decoration: BoxDecoration(
                  color: _currentQuestionIndex > 0 ? AppColor.primaryBlue : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _currentQuestionIndex > 0 ? _goToPreviousQuestion : null,
                  icon: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Chuẩn bị trạng thái trả lời để truyền vào bottom sheet
                  final List<String?> answerStates = _questionKeys.map((key) => widget.userAnswers[key]).toList();

                  showListAnswerBottomSheet(
                      context,
                      _questionKeys.length,
                      widget.userAnswers.keys.where((k) => widget.userAnswers[k] != null).length,
                      _currentQuestionIndex,
                      answerStates,
                          (index) => {}
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonprimaryCol,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Danh sách câu hỏi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Nút Tiến
              Container(
                decoration: BoxDecoration(
                  color: _currentQuestionIndex < _questionKeys.length - 1 ? AppColor.primaryBlue : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _currentQuestionIndex < _questionKeys.length - 1 ? _goToNextQuestion : null,
                  icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Hàm Xây dựng Đáp án (Review Mode) ĐÃ SỬA UI ---
  Widget _buildReviewAnswerBox({
    required String fullKey,       // Key Dài: "A. Tính..."
    required String answer,        // Nội dung đáp án (chính là fullKey)
    required String? selectedFullKey, // Key Dài người dùng đã chọn
    required String correctFullKey,   // Key Dài đáp án đúng
  }) {

    final bool isUserSelected = selectedFullKey == fullKey;
    final bool isCorrectAnswer = correctFullKey == fullKey;

    // --- Logic Màu Sắc ---
    Color containerColor;
    Color answerTextColor;

    if (isCorrectAnswer) {
      containerColor = Colors.green.shade100;
      answerTextColor = Colors.black;
    } else if (isUserSelected && !isCorrectAnswer) {
      containerColor = Colors.red.shade100;
      answerTextColor = Colors.black;
    } else {
      containerColor = Colors.white;
      answerTextColor = Colors.black;
    }

    // --- Giao diện ---
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
          border: isCorrectAnswer
              ? Border.all(color: Colors.green, width: 2) // Viền xanh cho đáp án đúng
              : (isUserSelected
              ? Border.all(color: Colors.red, width: 2) // Viền đỏ cho đáp án sai
              : null),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black38,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0.h), // Tăng padding để bù trừ cho vòng tròn đã xóa
          child: Row(
            children: [
              Expanded(
                child: Text(
                  fullKey, // Hiển thị toàn bộ Key Dài
                  style: TextStyle(
                    color: answerTextColor,
                    fontSize: 18.sp,
                    fontWeight: isUserSelected || isCorrectAnswer
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}