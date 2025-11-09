import 'package:flutter/material.dart';

// Định nghĩa màu xanh dương chung
const Color primaryBlue = Color(0xFF1877F2);

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  // Trạng thái cho các cài đặt (Dịch và tùy chỉnh nội dung)
  bool _specialOffers = true;      // Ưu đãi đặc biệt
  bool _soundEnabled = true;       // Âm thanh
  bool _vibrateEnabled = false;    // Rung
  bool _generalNotification = true; // Thông báo chung
  bool _promoDiscount = false;     // Khuyến mãi & Giảm giá
  bool _paymentOptions = true;     // Tùy chọn Thanh toán (Lưu thẻ)
  bool _appUpdate = true;          // Cập nhật ứng dụng
  bool _newServiceAvailable = false; // Dịch vụ mới (Tính năng ôn tập mới)
  bool _newTipsAvailable = false;  // Mẹo mới (Kiến thức/mẹo ôn tập mới)

  // Widget helper cho mỗi mục Switch - Tùy chỉnh để hiện đại hơn
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!value), // Cho phép tap toàn bộ tile
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.9, // Làm switch nhỏ gọn hơn
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: primaryBlue,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Nền sáng nhẹ cho hiện đại
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Cài đặt",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Căn giữa title cho đẹp
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        children: [
          // 1. Ưu đãi đặc biệt
          _buildSwitchTile(
            icon: Icons.local_offer_outlined,
            title: "Ưu đãi Đặc biệt",
            value: _specialOffers,
            onChanged: (val) => setState(() => _specialOffers = val),
          ),

          // 2. Âm thanh
          _buildSwitchTile(
            icon: Icons.volume_up_outlined,
            title: "Âm thanh (Khi làm bài/thông báo)",
            value: _soundEnabled,
            onChanged: (val) => setState(() => _soundEnabled = val),
          ),

          // 3. Rung
          _buildSwitchTile(
            icon: Icons.vibration_outlined,
            title: "Rung (Thông báo/Phản hồi)",
            value: _vibrateEnabled,
            onChanged: (val) => setState(() => _vibrateEnabled = val),
          ),

          // 4. Thông báo Chung
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: "Thông báo Chung (Tất cả)",
            value: _generalNotification,
            onChanged: (val) => setState(() => _generalNotification = val),
          ),

          // 5. Khuyến mãi & Giảm giá
          _buildSwitchTile(
            icon: Icons.percent_outlined,
            title: "Khuyến mãi & Giảm giá Gói ôn",
            value: _promoDiscount,
            onChanged: (val) => setState(() => _promoDiscount = val),
          ),

          // 6. Tùy chọn Thanh toán
          _buildSwitchTile(
            icon: Icons.credit_card_outlined,
            title: "Lưu Tùy chọn Thanh toán (Thẻ/Ví)",
            value: _paymentOptions,
            onChanged: (val) => setState(() => _paymentOptions = val),
          ),

          // 7. Cập nhật Ứng dụng
          _buildSwitchTile(
            icon: Icons.system_update_outlined,
            title: "Tự động Cập nhật Ứng dụng",
            value: _appUpdate,
            onChanged: (val) => setState(() => _appUpdate = val),
          ),

          // 8. Dịch vụ mới
          _buildSwitchTile(
            icon: Icons.new_releases_outlined,
            title: "Thông báo về Tính năng mới",
            value: _newServiceAvailable,
            onChanged: (val) => setState(() => _newServiceAvailable = val),
          ),

          // 9. Mẹo mới
          _buildSwitchTile(
            icon: Icons.lightbulb_outline,
            title: "Thông báo về Mẹo ôn tập mới",
            value: _newTipsAvailable,
            onChanged: (val) => setState(() => _newTipsAvailable = val),
          ),
        ],
      ),
    );
  }
}