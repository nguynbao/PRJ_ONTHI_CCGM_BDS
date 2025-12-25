import 'dart:async';

import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/total_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../models/dictionary.model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../youtube_video_section.dart';

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
  List<String?>
  selectedAnswers, // Danh sách đáp án đã chọn (Là Key Dài hoặc null)
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
                          ? AppColor.primaryBlue.withOpacity(
                              0.1,
                            ) // MÀU CHO CÂU ĐÃ TRẢ LỜI
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
                                selectedOptionForQuestion?.startsWith('A') ==
                                        true
                                    ? 'A'
                                    : null,
                                null,
                              ),
                              _buildAnswerButton(
                                'B',
                                selectedOptionForQuestion?.startsWith('B') ==
                                        true
                                    ? 'B'
                                    : null,
                                null,
                              ),
                              _buildAnswerButton(
                                'C',
                                selectedOptionForQuestion?.startsWith('C') ==
                                        true
                                    ? 'C'
                                    : null,
                                null,
                              ),
                              _buildAnswerButton(
                                'D',
                                selectedOptionForQuestion?.startsWith('D') ==
                                        true
                                    ? 'D'
                                    : null,
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
              const Text(
                // Dùng const
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

Future<void> _openYoutubeApp(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> showExplanationModal(
  BuildContext context,
  String explanation, {
  String? youtubeUrl,
}) async {
  await showDialog(
    context: context,
    useRootNavigator: true,
    builder: (ctx) {
      return AlertDialog(
        title: const Text(
          "Giải thích đáp án",
          style: TextStyle(
            color: AppColor.buttonprimaryCol,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(ctx).size.width * 0.9,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Cuộn mượt kiểu iOS
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (youtubeUrl != null && youtubeUrl.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubeVideoSection(
                      key: const ValueKey('youtube-player'),
                      videoUrl: youtubeUrl,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _openYoutubeApp("https://www.youtube.com/@tienkingbds"),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text("Mở trên YouTube"),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Nội dung giải thích:",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Đóng"),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    },
  );
}

// Popup xem chi tiết 1 thuật ngữ
void showTermDetailModal(BuildContext context, DictionaryTerm term) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              term.term,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              term.definition,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Đóng"),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> openTikTok(String url) async {
  try {
    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Không mở được TikTok: $e');
  }
}

// --- Quảng cáo Full Màn Hình (Interstitials Style) ---
void showTikTokAd(
  BuildContext context,
  String videoMp4Url,
  String tiktokOpenUrl,
  VoidCallback onClosed,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return _FullPageAdContent(
        videoMp4Url: videoMp4Url,
        tiktokUrl: tiktokOpenUrl,
        onClosed: onClosed,
      );
    },
  );
}

// Widget quản lý logic đếm ngược và UI Full Screen
class _FullPageAdContent extends StatefulWidget {
  final String videoMp4Url;
  final String tiktokUrl;
  final VoidCallback onClosed;

  const _FullPageAdContent({
    required this.videoMp4Url,
    required this.tiktokUrl,
    required this.onClosed,
  });

  @override
  State<_FullPageAdContent> createState() => _FullPageAdContentState();
}

class _FullPageAdContentState extends State<_FullPageAdContent> {
  int _secondsLeft = 5;
  Timer? _timer;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    // 1. Khởi tạo Video (Lấy link video mp4 từ Firebase Remote Config hoặc Storage)
    // Lưu ý: link này phải là link trực tiếp dẫn tới file .mp4
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoMp4Url))
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() {});
            _videoController!
              ..setLooping(true)
              ..play();
          });

    // 2. Đếm ngược
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose(); // Hủy video khi đóng ad
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Hiển thị Video Full Màn Hình
          GestureDetector(
            onTap: () => openTikTok(widget.tiktokUrl),
            child: SizedBox.expand(
              child:
                  _videoController != null &&
                      _videoController!.value.isInitialized
                  ? FittedBox(
                      fit: BoxFit
                          .cover, // Cắt video cho tràn màn hình giống TikTok
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ), // Đang tải video
            ),
          ),

          // Lớp phủ tối nhẹ để Text dễ đọc
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
              ),
            ),
          ),

          // 2. Nút đếm ngược / Đóng
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: _secondsLeft > 0 ? _buildTimerBadge() : _buildCloseButton(),
          ),

          // Gợi ý nhỏ ở dưới cùng
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Bấm vào màn hình để xem trên TikTok",
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Đóng sau ${_secondsLeft}s",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCloseButton() {
    return IconButton(
      onPressed: () {
        _videoController?.pause();
        Navigator.pop(context);
        widget.onClosed();
      },
      icon: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(Icons.close, color: Colors.white),
      ),
    );
  }
}
