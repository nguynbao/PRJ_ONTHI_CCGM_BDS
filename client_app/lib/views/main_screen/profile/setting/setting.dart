import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget{
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage>{
  // --- Màu chủ đạo (Đã đổi từ xanh lá sang Xanh Dương) ---
  final Color primaryColor = const Color(0xFF1877F2); // Màu xanh dương chính
  final Color primaryDarkColor = const Color(0xFF0961F5); // Màu xanh dương đậm

  // --- 1. Trạng thái cho THÔNG BÁO ĐẨY (PUSH NOTIFICATIONS) ---
  bool _pushNewTest = true;        // Bài thi mới
  bool _pushExpired = true;        // Hết hạn gói ôn
  bool _pushDailySummary = false;  // Tổng kết học tập
  bool _pushPromotion = true;      // Khuyến mãi

  // --- 2. Trạng thái cho THÔNG BÁO EMAIL ---
  bool _emailNewsletter = true;
  bool _emailPromotions = false;
  bool _emailArticles = true;
  bool _emailSystem = false;

  // --- 3. Trạng thái cho THÔNG BÁO SMS (Giữ nguyên hoặc đơn giản hóa) ---
  bool _smsOTP = true;         // Mã OTP
  bool _smsEmergency = true;   // Khẩn cấp (ít dùng)

  // --- 4. Trạng thái cho THỜI GIAN NHẮC NHỞ MỤC TIÊU ---
  String _targetReminderTime = '19:00 hàng ngày';
  final List<String> _reminderOptions = [
    'Không nhắc', '18:00 hàng ngày', '19:00 hàng ngày', '20:00 hàng ngày', '21:00 hàng ngày'
  ];


  // --- Widget helper cho mỗi mục Switch ---
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }

  // --- Widget helper cho khối Cài đặt ---
  Widget _buildSettingsBlock({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8, left: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDarkColor),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget helper cho Dropdown Tile ---
  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required ValueChanged<String?> onChanged,
    required List<String> options,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey)),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            style: TextStyle(fontSize: 15, color: primaryDarkColor, fontWeight: FontWeight.w600),
            onChanged: onChanged,
            items: options.map<DropdownMenuItem<String>>((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Nền xám nhạt
      appBar: AppBar(
        title: const Text("Cài đặt Thông báo"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // --- 1. KHỐI THÔNG BÁO ĐẨY (PUSH NOTIFICATIONS) ---
            _buildSettingsBlock(
              title: "Thông báo Đẩy (Push)",
              children: [
                _buildSwitchTile(
                  title: 'Bài thi thử/mô phỏng mới',
                  subtitle: 'Nhận thông báo khi có đề thi mới',
                  value: _pushNewTest,
                  onChanged: (val) => setState(() => _pushNewTest = val),
                ),
                _buildSwitchTile(
                  title: 'Cảnh báo hết hạn',
                  subtitle: 'Nhắc nhở về thời hạn gói ôn tập sắp hết',
                  value: _pushExpired,
                  onChanged: (val) => setState(() => _pushExpired = val),
                ),
                _buildSwitchTile(
                  title: 'Tổng kết học tập hàng ngày',
                  subtitle: 'Tóm tắt tiến độ, số câu đã ôn',
                  value: _pushDailySummary,
                  onChanged: (val) => setState(() => _pushDailySummary = val),
                ),
                // Mục cuối cùng
                _buildSwitchTile(
                  title: 'Thông báo Khuyến mãi/Ưu đãi',
                  subtitle: 'Nhận thông tin về các chương trình nâng cấp',
                  value: _pushPromotion,
                  onChanged: (val) => setState(() => _pushPromotion = val),
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 2. KHỐI THÔNG BÁO EMAIL ---
            _buildSettingsBlock(
              title: "Thông báo Email",
              children: [
                _buildSwitchTile(
                  title: 'Bản tin CCHNBĐS hàng tuần',
                  subtitle: 'Tóm tắt các thay đổi luật và thị trường',
                  value: _emailNewsletter,
                  onChanged: (val) => setState(() => _emailNewsletter = val),
                ),
                _buildSwitchTile(
                  title: 'Khuyến mãi và ưu đãi',
                  subtitle: 'Nhận thông tin về các chương trình',
                  value: _emailPromotions,
                  onChanged: (val) => setState(() => _emailPromotions = val),
                ),
                _buildSwitchTile(
                  title: 'Bài phân tích chuyên sâu',
                  subtitle: 'Các bài viết về kiến thức chuyên môn',
                  value: _emailArticles,
                  onChanged: (val) => setState(() => _emailArticles = val),
                ),
                // Mục cuối cùng
                _buildSwitchTile(
                  title: 'Thông báo hệ thống (Bắt buộc)',
                  subtitle: 'Thông báo về tài khoản, bảo mật, thanh toán',
                  value: _emailSystem,
                  onChanged: (val) => setState(() => _emailSystem = val),
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 3. KHỐI THÔNG BÁO SMS ---
            _buildSettingsBlock(
              title: "Thông báo SMS",
              children: [
                _buildSwitchTile(
                  title: 'Mã OTP bảo mật',
                  subtitle: 'Xác thực đăng nhập và giao dịch quan trọng',
                  value: _smsOTP,
                  onChanged: (val) => setState(() => _smsOTP = val),
                ),
                // Mục cuối cùng
                _buildSwitchTile(
                  title: 'Thông báo khẩn cấp',
                  subtitle: 'Cảnh báo bảo mật hoặc hệ thống ngừng hoạt động',
                  value: _smsEmergency,
                  onChanged: (val) => setState(() => _smsEmergency = val),
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 4. KHỐI THỜI GIAN NHẮC NHỞ (DROPDOWN) ---
            _buildSettingsBlock(
              title: "Đặt mục tiêu và nhắc nhở ôn tập",
              children: [
                // Thời gian nhắc nhở ôn tập
                _buildDropdownTile(
                  title: 'Thời gian nhắc nhở ôn tập',
                  subtitle: 'Nhận thông báo push/email vào thời điểm này để bắt đầu học',
                  value: _targetReminderTime,
                  options: _reminderOptions,
                  onChanged: (String? newValue) {
                    setState(() {
                      _targetReminderTime = newValue!;
                    });
                  },
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}