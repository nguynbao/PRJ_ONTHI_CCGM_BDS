// lib/shared/widgets/show_modal.dart
import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
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

            // icon minh họa (SVG tuỳ dự án)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
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
                      child: Text(secondaryText, style: TextStyle(color: Colors.black),),
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
