import 'package:flutter/material.dart';
import '../../../../common/app_button.dart'; // Giả định AppButton nằm ở đây

// Màu chính (được sử dụng cho các Switch và OutlinedButton)
const Color primaryBlue = Color(0xFF1877F2);

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool ghiNhoToi = true;
  bool nhanDangSinhTrac = true;
  bool faceID = false;
  bool vanTayID = false;

  void _onBiometricToggle(bool val) {
    setState(() {
      nhanDangSinhTrac = val;
      if (!val) {
        faceID = false;
        vanTayID = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Bảo mật"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MARK: - Switch List (Giữ nguyên)
            SwitchListTile(
              activeColor: primaryBlue,
              title: const Text("Ghi nhớ tôi"),
              value: ghiNhoToi,
              onChanged: (val) {
                setState(() {
                  ghiNhoToi = val;
                });
              },
            ),
            SwitchListTile(
              activeColor: primaryBlue,
              title: const Text("Nhận dạng sinh trắc"),
              value: nhanDangSinhTrac,
              onChanged: _onBiometricToggle,
            ),

            if (nhanDangSinhTrac)
              Column(
                children: [
                  SwitchListTile(
                    activeColor: primaryBlue,
                    title: const Text("Face ID"),
                    value: faceID,
                    onChanged: (val) {
                      setState(() {
                        faceID = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    activeColor: primaryBlue,
                    title: const Text("Nhận dạng vân tay"),
                    value: vanTayID,
                    onChanged: (val) {
                      setState(() {
                        vanTayID = val;
                      });
                    },
                  ),
                ],
              ),

            // Google Authenticator (Giữ nguyên)
            ListTile(
              title: const Text("Google Authenticator"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Chuyển sang trang Google Authenticator
              },
            ),

            const Spacer(),

            // MARK: - Buttons
            // Nút Đổi mã PIN (Giữ nguyên)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  foregroundColor: primaryBlue,
                  backgroundColor: Colors.grey.shade100,
                ),
                onPressed: () {},
                child: const Text(
                  "Đổi mã PIN",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // NÚT ĐỔI MẬT KHẨU: Thay thế bằng widget AppButton tái sử dụng
            SizedBox(
              width: double.infinity, // Đảm bảo AppButton giãn ra hết cỡ
              child: AppButton(
                content: "Đổi mật khẩu",
                onPressed: () {
                  print("Đổi mật khẩu đã được nhấn qua AppButton");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}