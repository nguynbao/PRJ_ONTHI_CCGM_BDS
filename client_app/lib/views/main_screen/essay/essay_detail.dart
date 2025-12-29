import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/essay.model.dart';
import '../../../controllers/essay.controller.dart';
import '../../../config/themes/app_color.dart';

class EssayDetailPage extends ConsumerStatefulWidget {
  final EssayModel essay;
  const EssayDetailPage({super.key, required this.essay});

  @override
  ConsumerState<EssayDetailPage> createState() => _EssayDetailPageState();
}

class _EssayDetailPageState extends ConsumerState<EssayDetailPage> {
  final TextEditingController _answerController = TextEditingController();
  bool _showKeys = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch state để lấy userProgress mới nhất
    final state = ref.watch(essayProvider);
    final notifier = ref.read(essayProvider.notifier);

    final progress = notifier.getProgress(widget.essay.id, widget.essay.keywords.length);
    final isDone = progress == 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.textpriCol),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Câu số ${widget.essay.rawIndex}",
          style: const TextStyle(color: AppColor.textpriCol, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            alignment: Alignment.center,
            child: Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDone ? AppColor.buttomSecondCol : AppColor.buttonprimaryCol
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- NỘI DUNG ĐỀ BÀI ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.buttonprimaryCol.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: AppColor.buttonprimaryCol.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.essay.category.toUpperCase(),
                    style: TextStyle(
                      color: AppColor.buttonprimaryCol,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.essay.content,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.textpriCol,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // --- THANH TIẾN ĐỘ ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mức độ thuộc bài", style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.textpriCol)),
                Text(
                  isDone ? "Đã thuộc lòng" : "Đang luyện tập",
                  style: TextStyle(fontSize: 12.sp, color: isDone ? AppColor.buttomSecondCol : Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10.h,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                    isDone ? AppColor.buttomSecondCol : AppColor.buttonprimaryCol
                ),
              ),
            ),
            SizedBox(height: 25.h),

            // --- Ô SOẠN THẢO ---
            Text(
              "Bài làm tự luận của bạn",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.textpriCol, fontSize: 15.sp),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: _answerController,
              maxLines: 10,
              style: const TextStyle(color: AppColor.textpriCol, height: 1.5),
              decoration: InputDecoration(
                hintText: "Hãy viết những gì bạn nhớ được về câu hỏi này...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: const BorderSide(color: AppColor.buttonprimaryCol),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // --- NÚT DÒ ĐÁP ÁN ---
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _showKeys = !_showKeys);
                  FocusScope.of(context).unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showKeys ? AppColor.textpriCol : AppColor.buttonprimaryCol,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  elevation: 0,
                ),
                child: Text(
                  _showKeys ? "ẨN GỢI Ý ĐÁP ÁN" : "DÒ Ý CHÍNH TRONG BÀI",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // --- BỘ TỪ KHÓA (CHIPS) ---
            if (_showKeys) ...[
              SizedBox(height: 25.h),
              Text(
                "Tích chọn các ý bạn đã nêu được:",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.textpriCol, fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: widget.essay.keywords.map((key) {
                  final isSelected = state.userProgress[widget.essay.id]?.contains(key) ?? false;
                  return FilterChip(
                    label: Text(key),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColor.textpriCol,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13.sp,
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      notifier.toggleKeyword(widget.essay.id, key);
                    },
                    selectedColor: AppColor.buttomSecondCol,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r), side: BorderSide.none),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}