import 'package:flutter/material.dart';

// Định nghĩa màu xanh dương chung
const Color primaryBlue = Color(0xFF1877F2);

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  // Trạng thái ngôn ngữ được chọn (0: Tiếng Việt, 1: English)
  int _selectedLanguage = 0;

  // Danh sách ngôn ngữ
  final List<Map<String, dynamic>> _languages = [
    {
      'icon': Icons.language,
      'title': 'Tiếng Việt',
      'code': 'vi',
    },
    {
      'icon': Icons.language,
      'title': 'English',
      'code': 'en',
    },
    {
      'icon': Icons.language,
      'title': 'English',
      'code': 'en',
    },
    // Có thể thêm nhiều ngôn ngữ hơn nếu cần
  ];

  // Widget helper cho mỗi mục ngôn ngữ
  Widget _buildLanguageTile({
    required IconData icon,
    required String title,
    required bool isSelected,
    required ValueChanged<int> onChanged,
    required int index,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(index),
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
              Radio<int>(
                value: index,
                groupValue: _selectedLanguage,
                onChanged: (value) => onChanged(value!),
                activeColor: primaryBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          "Ngôn ngữ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Căn giữa title cho đẹp
        actions: [
          // Nút lưu thay đổi (có thể tùy chỉnh)
          TextButton(
            onPressed: () {
              // Xử lý lưu ngôn ngữ (ví dụ: setLocale hoặc lưu SharedPreferences)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu thay đổi ngôn ngữ!')),
              );
            },
            child: const Text(
              'Lưu',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        children: [
          // Lặp qua danh sách ngôn ngữ
          ..._languages.asMap().entries.map((entry) {
            final index = entry.key;
            final lang = entry.value;
            return _buildLanguageTile(
              icon: lang['icon'],
              title: lang['title'],
              isSelected: _selectedLanguage == index,
              onChanged: (value) => setState(() => _selectedLanguage = value),
              index: index,
            );
          }).toList(),
        ],
      ),
    );
  }
}