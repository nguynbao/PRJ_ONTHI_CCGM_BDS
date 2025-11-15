import 'package:flutter/material.dart';
import 'package:animations/animations.dart'; // Thư viện cho PageTransitionSwitcher

// ====================================================================
// I. DATA MODEL (flashcard_model.dart)
// ====================================================================

class FlashcardSet {
  final String title;
  final String subtitle;
  final int totalCards;
  final int completedCards;
  final String difficulty;
  final int markedCards;

  FlashcardSet({
    required this.title,
    required this.subtitle,
    required this.totalCards,
    required this.completedCards,
    required this.difficulty,
    required this.markedCards,
  });
}

// Dữ liệu mẫu
final List<FlashcardSet> sampleSets = [
  FlashcardSet(
    title: 'Luật Kinh doanh Bất động sản',
    subtitle: 'Khái niệm, điều kiện, quyền và nghĩa vụ',
    totalCards: 45,
    completedCards: 32,
    difficulty: 'Cơ bản',
    markedCards: 12,
  ),
  FlashcardSet(
    title: 'Môi giới Bất động sản',
    subtitle: 'Điều kiện hành nghề, quyền và nghĩa vụ',
    totalCards: 38,
    completedCards: 15,
    difficulty: 'Cơ bản',
    markedCards: 8,
  ),
  FlashcardSet(
    title: 'Hợp đồng Bất động sản',
    subtitle: 'Các loại hợp đồng và điều khoản',
    totalCards: 52,
    completedCards: 40,
    difficulty: 'Nâng cao',
    markedCards: 15,
  ),
  FlashcardSet(
    title: 'Thủ tục pháp lý BĐS',
    subtitle: 'Quy trình, hồ sơ và các loại phí',
    totalCards: 30,
    completedCards: 5,
    difficulty: 'Nâng cao',
    markedCards: 3,
  ),
  FlashcardSet(
    title: 'Định giá và Quản lý BĐS',
    subtitle: 'Phương pháp định giá, quản lý tài sản',
    totalCards: 60,
    completedCards: 5,
    difficulty: 'Cơ bản',
    markedCards: 0,
  ),
  FlashcardSet(
    title: 'Quy hoạch Đô thị',
    subtitle: 'Pháp luật về quy hoạch, các loại đất',
    totalCards: 75,
    completedCards: 60,
    difficulty: 'Nâng cao',
    markedCards: 20,
  ),
];

// ====================================================================
// II. FLASHCARD CARD WIDGET (flashcard_set_card.dart)
// (Giữ nguyên)
// ====================================================================

class FlashcardSetCard extends StatelessWidget {
  final FlashcardSet set;

  const FlashcardSetCard({
    super.key,
    required this.set,
  });

  @override
  Widget build(BuildContext context) {
    final double completionPercentage = set.totalCards > 0 ? set.completedCards / set.totalCards : 0.0;
    final String percentText = (completionPercentage * 100).toStringAsFixed(0);
    Color progressColor = completionPercentage >= 0.9 ? Colors.green.shade700 : (completionPercentage >= 0.5 ? Colors.blue : Colors.redAccent);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    set.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.business_center_rounded,
                  color: progressColor,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              set.subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            // Thông tin nhanh: Số thẻ, Độ khó, Thẻ đã đánh dấu
            Row(
              children: [
                Text('${set.totalCards} thẻ', style: const TextStyle(fontWeight: FontWeight.w500)),
                const Text(' • ', style: TextStyle(color: Colors.grey)),
                Text(set.difficulty, style: const TextStyle(color: Colors.orange)),
                const Text(' • ', style: TextStyle(color: Colors.grey)),
                Icon(
                  Icons.bookmark_rounded,
                  size: 16,
                  color: Colors.orange.shade700,
                ),
                Text(' ${set.markedCards}', style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            // Thanh Tiến độ
            Row(
              children: [
                const Text('Tiến độ', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: completionPercentage,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${set.completedCards}/${set.totalCards} ($percentText%)',
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// III. FLASHCARD PAGE WIDGET (flashcard_page.dart) - ĐÃ LOẠI BỎ Scaffold VÀ AppBar
// ====================================================================

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  String _selectedTab = 'Tất cả';

  // --- BUILD METHOD CHÍNH ---
  @override
  Widget build(BuildContext context) {
    // Trả về Widget body, không phải Scaffold
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- Thanh Chọn Lọc (Tab Menu) ---
          _buildTabMenu(),
          const SizedBox(height: 20),

          // --- Danh Sách Bộ Flashcard (Sử dụng Expanded + ListView.builder) ---
          Expanded(
            child: _buildFlashcardList(),
          ),
        ],
      ),
    );
  }

  // --- WIDGET METHOD: Tab Menu ---
  Widget _buildTabMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _buildTabButton('Tất cả', sampleSets.length, Icons.grid_view_rounded),
          _buildTabButton('Đánh dấu', 5, Icons.star_rounded),
          _buildTabButton('Theo chuyên đề', null, Icons.book_rounded),
          _buildTabButton('Cần luyện', null, Icons.local_fire_department_rounded),
          _buildTabButton('Của tôi', null, Icons.person_rounded),
        ],
      ),
    );
  }

  // --- WIDGET METHOD: Nút Tab ---
  Widget _buildTabButton(String title, int? count, IconData icon) {
    final bool isSelected = _selectedTab == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _selectedTab = title;
          });
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.blue,
          backgroundColor: isSelected ? Colors.blue : Colors.white,
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        // Sửa icon: chỉ hiện icon nếu count == null (như code gốc của bạn)
        icon: count != null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (count != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET METHOD: Danh sách Card (Dùng ListView.builder) ---
  Widget _buildFlashcardList() {
    return ListView.builder(
      itemCount: sampleSets.length,
      itemBuilder: (context, index) {
        return FlashcardSetCard(
          set: sampleSets[index],
        );
      },
    );
  }
}