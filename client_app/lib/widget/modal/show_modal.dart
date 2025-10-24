// lib/shared/widgets/show_modal.dart
import 'package:client_app/config/assets/app_icon.dart';
import 'package:client_app/config/assets/app_images.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Hiển thị modal thông báo thành công ở giữa màn hình.
/// - [title] & [message]: nội dung hiển thị.
/// - [autoCloseAfter]: nếu truyền vào (ví dụ: Duration(seconds: 2)),
///   dialog sẽ tự đóng sau khoảng thời gian đó.
/// - [barrierDismissible]: cho phép chạm ra ngoài để đóng.
/// - [icon], [accentColor]: tùy chỉnh giao diện.
/// Trả về Future hoàn thành khi dialog được đóng.
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
                  child: SvgPicture.asset(AppIcon.imgPassSetting),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textpriCol)
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child:  Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  // Tự đóng sau thời gian chỉ định (nếu có)
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
