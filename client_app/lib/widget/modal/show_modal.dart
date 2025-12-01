import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/total_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Future<void> showSuccessDialog(
  BuildContext context, {
  String title = 'Thành công',
  String message = 'Thao tác đã hoàn tất!',
  Duration? autoCloseAfter,
  bool barrierDismissible = true,
  IconData icon = Icons.check_circle,
  Color? accentColor,
  VoidCallback? onClosed,
}) async {
  final theme = Theme.of(context);
  // Gọi dialog chuẩn Material, tự căn giữa.
  final future = showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black54,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AppIcons.imgPassSetting),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textpriCol),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (autoCloseAfter != null) {
    Future.delayed(autoCloseAfter, () {
      // Tránh lỗi nếu đã đóng
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) navigator.pop();
    });
  }

  await future;
  onClosed?.call();
}

Future<void> showRemoveBottomSheet(
  BuildContext context, {
  String title = 'Remove From Bookmark?',
  String message = 'Thao tác đã hoàn tất!',
  String primaryText = 'Yes, Remove',
  VoidCallback? onPrimary,
  String? secondaryText = 'Cancel',
  VoidCallback? onSecondary,
  bool isDismissible = true,
}) async {
  final theme = Theme.of(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    backgroundColor: Color(0xffF5F9FF),
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      final bottom = MediaQuery.of(ctx).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'courses',
                                    style: TextStyle(
                                      color: AppColor.buttomThirdCol,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(AppVector.iconTag),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                "topic",
                                style: TextStyle(
                                  color: AppColor.textpriCol,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                if (secondaryText != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        onSecondary?.call();
                      },
                      child: Text(
                        secondaryText,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onPrimary?.call();
                    },
                    child: Text(primaryText),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showBackModalExam(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rời bài kiểm tra",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.buttonprimaryCol,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'BẠN CÓ CHẮC CHẮN MUỐN \n RỜI BÀI KIỂM TRA KHÔNG',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black38),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tiếp tục làm bài"),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.pop(context),
                },
                child: Text(
                  "Rời đi",
                  style: TextStyle(color: AppColor.buttonprimaryCol),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  print("Dialog đã đóng xong.");
}

Widget _buildAnswerButton(
  String option, // 'A', 'B', 'C', 'D'
  String? selectedAnswer, // Đáp án đã chọn cho câu hỏi này
  VoidCallback? onTap,
) {
  // Xác định xem đáp án này có phải là đáp án đã chọn không
  final bool isSelected = selectedAnswer == option;

  // Định nghĩa màu dựa trên trạng thái chọn
  final Color backgroundColor = isSelected ? Colors.blue : Colors.white;
  final Color textColor = isSelected ? Colors.white : Colors.black;

  return TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(padding: EdgeInsets.zero),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
        ), // Thêm border cho đẹp
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    ),
  );
}

Future<void> showListAnswerBottomSheet(
    BuildContext context,
    int totalQuestions,
    int answeredQuestions,
    int questionIndex,
    List<String?> selectedAnswers, // Danh sách đáp án đã chọn (Là Key Dài hoặc null)
    Function(int index) onJumpToQuestion,
    ) async {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xffF4F2F2),

    builder: (ctx) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Danh sách các câu hỏi($answeredQuestions/$totalQuestions)",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(totalQuestions, (index) {
                      final questionNumber = index + 1;

                      final String? selectedOptionForQuestion =
                      selectedAnswers.length > index
                          ? selectedAnswers[index]
                          : null;

                      // LƯU Ý: selectedOptionForQuestion LÀ KEY DÀI ("A. Tính pháp lý") HOẶC NULL

                      final bool isCurrent = index == questionIndex;
                      final bool isAnswered = selectedOptionForQuestion != null;

                      final Color rowColor = isCurrent
                          ? Colors.blue.withOpacity(0.1) // Câu hiện tại
                          : isAnswered
                          ? AppColor.primaryBlue.withOpacity(0.1) // MÀU CHO CÂU ĐÃ TRẢ LỜI
                          : Colors.transparent;

                      void jumpToQuestion() {
                        Navigator.pop(context);
                        onJumpToQuestion(index);
                      }

                      return InkWell(
                        onTap: jumpToQuestion,
                        child: Container(
                          color: rowColor,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // 1. Text Câu hỏi
                              SizedBox(
                                width: 80,
                                child: Text(
                                  "Câu hỏi $questionNumber",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // 2. Các nút đáp án (Giờ chỉ để hiển thị trạng thái)
                              // Vấn đề: Chúng ta chỉ lưu KEY DÀI, nên không thể so sánh 'A' với 'A. Tính pháp lý'
                              // Ta sẽ chỉ so sánh Label ngắn ('A') với Label ngắn đã trích xuất từ Key Dài.

                              _buildAnswerButton(
                                'A',
                                selectedOptionForQuestion?.startsWith('A') == true ? 'A' : null,
                                null,
                              ),
                              _buildAnswerButton(
                                'B',
                                selectedOptionForQuestion?.startsWith('B') == true ? 'B' : null,
                                null,
                              ),
                              _buildAnswerButton(
                                'C',
                                selectedOptionForQuestion?.startsWith('C') == true ? 'C' : null,
                                null,
                              ),
                              _buildAnswerButton(
                                'D',
                                selectedOptionForQuestion?.startsWith('D') == true ? 'D' : null,
                                null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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

Future<void> showSuccessModalExam(
    BuildContext context, {
      VoidCallback? onConfirm,
    }) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text( // Dùng const
                "Nộp bài kiểm tra",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.buttonprimaryCol,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'BẠN CÓ CHẮC CHẮN MUỐN \n NỘP BÀI KIỂM TRA KHÔNG',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black38),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm?.call();
                },
                child: const Text("Nộp bài kiểm tra"),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text(
                  "Quay lại",
                  style: TextStyle(color: AppColor.buttonprimaryCol),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  print("Dialog đã đóng xong.");
}

Future<void> showExplanationModal(BuildContext ctx1, String explanation) async {
  await showDialog(
    context: ctx1,
    builder: (ctx1) {
      return AlertDialog(
        title: const Text(
          "Giải thích đáp án",
          style: TextStyle(
            color: AppColor.buttonprimaryCol, fontWeight: FontWeight.bold
          ),
        ),
        content: Container(
          height: MediaQuery.of(ctx1).size.height * 0.4,
          width: MediaQuery.of(ctx1).size.width * 0.6,
          child: SingleChildScrollView(
            child: Text(explanation),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx1),
            child: const Text("Đóng"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      );
    },
  );
}