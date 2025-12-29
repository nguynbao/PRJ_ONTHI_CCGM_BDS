import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/total_exam_page.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:client_app/controllers/exam.controller.dart';
import 'package:client_app/models/exam.model.dart';
import 'dart:async';

class InsideExamPage extends StatefulWidget {
  final String courseId;
  final String examId;

  const InsideExamPage({
    super.key,
    required this.courseId,
    required this.examId,
  });

  @override
  State<InsideExamPage> createState() => _InsideExamPageState();
}

class _InsideExamPageState extends State<InsideExamPage> {

  final ExamController _examController = ExamController();

  int _currentQuestionIndex = 0;

  Map<String, String?> _userAnswers = {};

  // Dữ liệu đã tải từ Firestore
  late Future<Exam?> _examDetailsFuture;
  Exam? _examDetails;

  Map<String, dynamic> _rawQuestionsData = {}; // Map câu hỏi (lấy từ _examDetails.questions)
  List<String> _questionKeys = [];

  Timer? _timer;
  int _remainingSeconds = 0;

  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _examDetailsFuture = _examController.getExamDetails(
      courseId: widget.courseId,
      examId: widget.examId,
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // ⚠️ Quan trọng: Hủy timer khi Widget bị dispose
    super.dispose();
  }

  void _startTimer() {
    if (_examDetails == null) return;

    // Chuyển thời gian từ phút sang giây
    _remainingSeconds = _examDetails!.durationMinutes;

    // Nếu thời gian là 0, không cần chạy timer
    if (_remainingSeconds <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        // Hết giờ!
        timer.cancel();
        _autoSubmitExam(); // Tự động nộp bài khi hết giờ
      }
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Hàm xử lý tự động nộp bài (Giống như khi bấm nút Done)
  void _autoSubmitExam() {
    // Logic tính điểm giống như nút Done
    int correctCount = 0;
    for (var questionKey in _questionKeys) {
      final selectedAnswer = _userAnswers[questionKey];
      final Map<String, dynamic> firestoreOptions =
          _rawQuestionsData[questionKey] as Map<String, dynamic>? ?? {};

      final String correctAnswerLabel = firestoreOptions.keys.firstWhere(
              (key) => firestoreOptions[key] == true,
          orElse: () => ''
      );

      if (selectedAnswer != null && selectedAnswer == correctAnswerLabel) {
        correctCount++;
      }
    }

    final Duration timeElapsed = DateTime.now().difference(_startTime);
    final int secondsSpent = timeElapsed.inSeconds;

    final String actualExamName = _examDetails?.name ?? "Bài thi";
    final int actualDuration = _examDetails?.durationMinutes ?? 0;

    // Điều hướng sang TotalExamPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TotalExamPage(
          courseId: widget.courseId,
          examId: widget.examId,
          examName: actualExamName,
          totalQuestions: _questionKeys.length,
          correctAnswers: correctCount,
          durationMinutes: (_examDetails?.durationMinutes ?? 0) ~/ 60,
          timeSpentSeconds: secondsSpent,
          userAnswers: _userAnswers,
        ),
      ),
    );
  }

  // Logic Chuyển Câu
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
    return FutureBuilder<Exam?>(
      future: _examDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColor.buttonprimaryCol)),
          );
        }

        if (snapshot.hasError || snapshot.data == null || snapshot.data!.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Lỗi tải bài thi hoặc bài thi không có câu hỏi.")),
          );
        }

        // Xử lý dữ liệu đã tải lần đầu
        if (_questionKeys.isEmpty) {
          _examDetails = snapshot.data;

          if (_examDetails == null || _examDetails!.questions.isEmpty) {
            return const Scaffold(body: Center(child: Text("Bài thi không có câu hỏi.")));
          }

          // Lấy tất cả các Key
          _rawQuestionsData = _examDetails!.questions; // Lấy Map câu hỏi từ đối tượng Exam
          _questionKeys = _rawQuestionsData.keys.toList();

          _questionKeys.sort((a, b) {
            final RegExp regExp = RegExp(r'Câu\s+(\d+)\s*:');
            final matchA = regExp.firstMatch(a);
            final matchB = regExp.firstMatch(b);

            if (matchA == null || matchB == null) return 0;

            final numA = int.tryParse(matchA.group(1) ?? '0') ?? 0;
            final numB = int.tryParse(matchB.group(1) ?? '0') ?? 0;

            return numA.compareTo(numB); // So sánh số: 1 < 2 < 3...
          });

          // Khởi tạo trạng thái đáp án
          for (var key in _questionKeys) {
            _userAnswers[key] = null;
          }

          _startTimer();
        }

        return _buildExamContent(context);
      },
    );
  }

  // Hàm xây dựng nội dung Quiz
  Widget _buildExamContent(BuildContext context) {
    if (_questionKeys.isEmpty) return const SizedBox();

    // Lấy dữ liệu câu hỏi hiện tại
    final currentQuestionKey = _questionKeys[_currentQuestionIndex];
    final Map<String, dynamic> currentOptionsMap =
        _rawQuestionsData[currentQuestionKey] as Map<String, dynamic>? ?? {};

    // Đáp án người dùng đã chọn cho câu hiện tại
    final String? selectedLabel = _userAnswers[currentQuestionKey];

    // Danh sách các Label đáp án để hiển thị (A, B, C, D)
    final List<String> optionLabels = currentOptionsMap.keys
      .cast<String>()
      .where((key) => key != 'explanation' && key != 'youtubeUrl')
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
              onPressed: () => showBackModalExam(context),
              icon: Image.asset(AppIcons.imgBack),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Câu ${_currentQuestionIndex + 1}/${_questionKeys.length}", // Hiển thị số câu hỏi
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),

            // NÚT NỘP BÀI
            IconButton(
              onPressed: () {
                showSuccessModalExam(
                  context,
                  onConfirm: () {
                    _autoSubmitExam();
                  },
                );
              },
              icon: const Icon(Icons.done, color: Colors.white),
            ),
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

                      ...optionLabels.map((label) {

                        final String fullKey = currentOptionsMap.keys.firstWhere(
                          (key) => key.startsWith(label),
                          orElse: () => label
                        );

                        final String answerContent = fullKey;

                        return _buildAnswerBox(
                          fullKey,
                          answerContent,
                          selectedLabel,
                          currentQuestionKey,
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
                  // 1. Duyệt qua _questionKeys theo thứ tự để đảm bảo đúng Index
                  final List<String?> answerStates = _questionKeys.map((key) {
                    return _userAnswers[key];
                  }).toList();

                  showListAnswerBottomSheet(
                      context,
                      _questionKeys.length, // Tổng số câu
                      _userAnswers.keys.where((k) => _userAnswers[k] != null).length, // Số câu đã trả lời
                      _currentQuestionIndex, // Truyền index câu hiện tại
                      answerStates, // truyền vào trạng thái đã sắp xếp

                          (newIndex) {
                        setState(() {
                          _currentQuestionIndex = newIndex; // Cập nhật Index
                        });
                      }
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

  Widget _buildAnswerBox(
      String fullKey, // "A", "B", "C", "D"
      String answer, // Nội dung đáp án (tạm thời Hardcode)
      String? selectedFullKey, // Label đang được chọn (từ _userAnswers)
      String questionKey, // Key câu hỏi hiện tại
      ) {

    final bool isSelected = selectedFullKey == fullKey;

    final containerColor = isSelected
        ? AppColor.buttonprimaryCol
        : Colors.white;
    final answerTextColor = isSelected ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        setState(() {
          if (selectedFullKey == fullKey) {
            _userAnswers[questionKey] = null;
          } else {
            _userAnswers[questionKey] = fullKey;
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: AppColor.buttonprimaryCol, width: 2)
                : null,
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
            // Tăng padding ngang để tạo không gian
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    // Hiển thị nội dung đáp án (ví dụ: "A. Nội dung đáp án")
                    fullKey,
                    style: TextStyle(
                      color: answerTextColor,
                      fontSize: 19.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}