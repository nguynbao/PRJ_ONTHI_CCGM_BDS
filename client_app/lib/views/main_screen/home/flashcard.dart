import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../controllers/flashcard.controller.dart'; // Giả định FlashcardService nằm ở đây
import '../../../models/flashcard_set.model.dart';
import '../flash_card/add_flashcard.dart';
import '../flash_card/flashcard_detail.dart';

class FlashcardPage extends StatefulWidget {
  // Thường dùng static const routeName nếu dùng định tuyến named routes
  static const String routeName = '/flashcardPage';

  final VoidCallback? onBackToHome;

  const FlashcardPage({super.key, this.onBackToHome});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  // Đảm bảo FlashcardService có thể truy cập được
  final FlashcardService _flashcardService = FlashcardService();
  String _selectedTab = 'Tất cả';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      _loadTabCounts();
    });
  }


  // Hàm điều hướng đến trang tạo bộ đề mới
  void _navigateToAddSet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFlashcardSetPage(),
      ),
    ).then((_) {
      // Sau khi quay lại, tải lại số lượng tab để cập nhật 'Tất cả' và 'Của tôi'
      _loadTabCounts();
    });
  }

  Future<void> _loadTabCounts() async {
    final userId = _flashcardService.userId;
    if (userId == null) {
      // Nếu chưa đăng nhập, chỉ tính tab 'Tất cả'
      final allSets = await _flashcardService.getAllFlashcardSetsFuture(); // Cần tạo hàm Future này
      setState(() {
        _tabCounts['Tất cả'] = allSets.length;
      });
      return;
    }

    // Lấy dữ liệu cho các tab cá nhân
    final allSetsFuture = _flashcardService.getAllFlashcardSetsFuture();
    final savedSetsFuture = _flashcardService.getSavedSetsFuture(userId); // Cần tạo hàm Future này
    final mySetsFuture = _flashcardService.getSetsCreatedByFuture(userId); // Cần tạo hàm Future này

    final results = await Future.wait([allSetsFuture, savedSetsFuture, mySetsFuture]);

    // Cập nhật State
    setState(() {
      _tabCounts['Tất cả'] = (results[0] as List).length;
      // _tabCounts['Đánh dấu'] = (results[1] as List).length;
      _tabCounts['Của tôi'] = (results[2] as List).length;
      // (Bỏ qua 'Theo chuyên đề' và 'Cần luyện' trong ví dụ này)
    });
  }

  Map<String, int> _tabCounts = {
    'Tất cả': 0,
    // 'Đánh giá': 0,
    'Của tôi': 0,
    'Theo chuyên đề': 0,
    'Cần luyện': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // Chỉ sử dụng Padding cho phần body
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTabMenu(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildFlashcardList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSet,
        backgroundColor: AppColor.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    // Nội dung không đổi
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16.0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              if (widget.onBackToHome != null) {
                widget.onBackToHome!();
              } else {
                // Chỉ dùng pop() làm fallback nếu nó được push lên như một Route
                Navigator.of(context).pop();
              }
            },
            icon: Image.asset(AppIcons.imgBack, color: Colors.black),
          ),
          const Spacer(),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flashcard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Ôn thi chứng chỉ hành nghề BĐS',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.bar_chart_rounded, color: Colors.black87),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black87),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabMenu() {

    final userId = _flashcardService.userId;

    // Nội dung không đổi
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _buildTabButton('Tất cả', _tabCounts['Tất cả'], Icons.grid_view_rounded),
          userId == null
              ? _buildTabButton('Đánh dấu', 0, Icons.star_rounded) // Nếu chưa đăng nhập
              : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('saved_sets')
                .snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return _buildTabButton('Đánh dấu', count, Icons.star_rounded);
            },
          ),
          _buildTabButton('Theo chuyên đề', null, Icons.book_rounded),
          _buildTabButton('Cần luyện', null, Icons.local_fire_department_rounded),
          _buildTabButton('Của tôi', _tabCounts['Của tôi'], Icons.person_rounded),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int? count, IconData icon) {
    // Nội dung không đổi
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

  Widget _buildFlashcardList() {
    // Logic lấy stream dựa trên tab không đổi
    Stream<List<FlashcardSet>> stream;
    final userId = _flashcardService.userId;

    if (userId == null && (_selectedTab == 'Của tôi' || _selectedTab == 'Đánh dấu' || _selectedTab == 'Cần luyện')) {
      stream = Stream.value([]);
    } else if (_selectedTab == 'Tất cả') {
      stream = _flashcardService.getAllFlashcardSetsStream();
    } else if (_selectedTab == 'Đánh dấu') {
      stream = FirebaseFirestore.instance
          .collection('users')
          .doc(_flashcardService.userId)
          .collection('saved_sets')
          .snapshots()
          .asyncMap((snapshot) async {
        if (snapshot.docs.isEmpty) return [];

        final setIds = snapshot.docs.map((e) => e.id).toList();

        // Xử lý giới hạn 10 cho whereIn (giữ nguyên logic cũ)
        if (setIds.isEmpty) return [];
        final setsSnapshot = await FirebaseFirestore.instance
            .collection('flashcard_sets')
            .where(FieldPath.documentId, whereIn: setIds)
            .get();

        return setsSnapshot.docs.map((doc) => FlashcardSet.fromMap(doc.id, doc.data())).toList();
      });
    } else if (_selectedTab == 'Của tôi') {
      stream = _flashcardService.getSetsCreatedBy(userId!);
    } else if (_selectedTab == 'Cần luyện') {
      stream = _flashcardService.getPublicFlashcardSets();
    } else {
      stream = _flashcardService.getPublicFlashcardSets();
    }

    return StreamBuilder<List<FlashcardSet>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Không tìm thấy bộ flashcard nào."),
          );
        }

        List<FlashcardSet> sets = snapshot.data!;

        if (_selectedTab == 'Cần luyện') {
          // Hoặc sử dụng một Future/StreamBuilder wrapper ở đây:
          return FutureBuilder<List<FlashcardSet>>(
              future: _filterSetsForPractice(sets),
              builder: (context, filteredSnapshot) {
                if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final filteredSets = filteredSnapshot.data ?? [];

                if (filteredSets.isEmpty) {
                  return const Center(child: Text("Bạn đã hoàn thành tất cả bộ đề!"));
                }

                return ListView.builder(
                  itemCount: filteredSets.length,
                  itemBuilder: (context, index) {
                    return FlashcardSetCard(set: filteredSets[index]);
                  },
                );
              }
          );
        }

        return ListView.builder(
          itemCount: sets.length,
          itemBuilder: (context, index) {
            // Truyền bộ đề vào Card
            return FlashcardSetCard(set: sets[index]);
          },
        );
      },
    );
  }

  // Code chạy một lần để cập nhật tất cả sets cũ
  Future<void> migrateLegacySetsToPublic() async {
    final setsRef = FirebaseFirestore.instance.collection('flashcard_sets');

    // Lấy tất cả các sets mà thiếu trường isPublic
    final querySnapshot = await setsRef
        .where('isPublic', isNull: true) // Truy vấn những tài liệu thiếu trường isPublic
        .limit(500) // Nên giới hạn số lượng trong mỗi lần chạy
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {
        'isPublic': true, // Mặc định là công khai
        // Có thể thêm một creatorId giả nếu bạn cần sau này
        // 'creatorId': 'LEGACY_USER',
      });
    }

    await batch.commit();
    print('Đã cập nhật ${querySnapshot.size} bộ đề cũ thành công khai.');
  }

  // Hàm lọc set cần luyện (chạy trên client)
  Future<List<FlashcardSet>> _filterSetsForPractice(List<FlashcardSet> sets) async {
    List<FlashcardSet> result = [];

    // Kiểm tra userId ở đây để tránh gọi service nếu không cần thiết
    if (_flashcardService.userId == null) {
      // Nếu chưa đăng nhập, không có tiến độ cá nhân để lọc
      return [];
    }

    for (var set in sets) {
      // Gọi service để lấy tiến độ
      final progress = await _flashcardService.getProgressOfSetFuture(set.id);

      // 🔥 KHẮC PHỤC LỖI: Lấy giá trị an toàn và đảm bảo kiểu là int (hoặc dùng as int!)
      // Sử dụng '?? 0' để xử lý null an toàn và đảm bảo kết quả là int
      final int completed = progress['completed'] ?? 0;
      final int total = progress['total'] ?? 0;

      // So sánh an toàn: Cần luyện nếu đã hoàn thành < tổng số thẻ
      if (completed < total) {
        result.add(set);
      }
    }
    return result;
  }
}

class FlashcardSetCard extends StatelessWidget {
  final FlashcardSet set;

  const FlashcardSetCard({
    super.key,
    required this.set,
  });

  @override
  Widget build(BuildContext context) {
    final FlashcardService service = FlashcardService();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardSetDetailPage(set: set),
          ),// Truyền FlashcardSet qua argument
        );
      },
      // Sử dụng StreamBuilder để lắng nghe tiến độ của User cho bộ đề này
      child: StreamBuilder<Map<String, int>>(
        stream: service.getProgressStreamOfSet(set.id),
        builder: (context, snapshot) {
          // Lấy dữ liệu tiến độ, nếu chưa có thì dùng giá trị mặc định (0)
          final int totalCards = snapshot.data?['total'] ?? 0;
          final int completedCards = snapshot.data?['completed'] ?? 0;
          final int markedCards = snapshot.data?['marked'] ?? 0;

          // Tính toán dựa trên dữ liệu cá nhân
          final double completionPercentage =
          totalCards > 0 ? completedCards / totalCards : 0.0;
          final String percentText = (completionPercentage * 100).toStringAsFixed(0);

          Color progressColor = completionPercentage >= 0.9
              ? Colors.green.shade700
              : (completionPercentage >= 0.5 ? Colors.blue : Colors.redAccent);

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
                          set.title, // Lấy từ FlashcardSet chung
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
                    set.subtitle, // Lấy từ FlashcardSet chung
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Thông tin nhanh: Số thẻ, Độ khó, Thẻ đã đánh dấu
                  Row(
                    children: [
                      Text('$totalCards thẻ', style: const TextStyle(fontWeight: FontWeight.w500)),
                      const Text(' • ', style: TextStyle(color: Colors.grey)),
                      Text(set.difficulty, style: const TextStyle(color: Colors.orange)),
                      const Text(' • ', style: TextStyle(color: Colors.grey)),
                      Icon(
                        Icons.bookmark_rounded,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                      Text(' $markedCards', style: const TextStyle(fontWeight: FontWeight.w500)),
                      const Spacer(),

                      // ✅ 2) StreamBuilder kiểm tra Saved/Favorite
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(service.userId)
                            .collection('saved_sets')
                            .doc(set.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          // Kiểm tra xem document tồn tại (đã lưu) hay không
                          bool isSaved = snapshot.data?.exists == true;

                          return IconButton(
                            icon: Icon(
                              isSaved ? Icons.favorite : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => service.toggleSaveSet(set.id),
                          );
                        },
                      ),
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
                        '$completedCards/$totalCards ($percentText%)',
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
        },
      ),
    );
  }
}