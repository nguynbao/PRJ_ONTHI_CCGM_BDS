import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.content, required this.onPressed});
  final String content;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Giảm padding ngang tối thiểu để Stack hoạt động tốt hơn
            padding: EdgeInsets.zero,
            foregroundColor: Colors.white,
            backgroundColor: AppColor.buttonprimaryCol,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
        ),
        onPressed: onPressed,
        // Dùng STACK để xếp chồng chữ và icon
        child: Stack(
          alignment: Alignment.center, // Căn giữa nội dung chính
          children: [
            // 1. CHỮ (Căn giữa tuyệt đối)
            Center(
              child: Text(
                content,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),

            // 2. ICON (Căn sát mép phải)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                // Thêm padding bên phải cho icon để nó không dính sát mép nút
                padding: EdgeInsets.only(right: 8.w),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                    child: Center(
                        child: Icon(
                          Iconsax.arrow_right_14,
                          size: 20,
                          color: AppColor.buttonprimaryCol,
                        )
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}