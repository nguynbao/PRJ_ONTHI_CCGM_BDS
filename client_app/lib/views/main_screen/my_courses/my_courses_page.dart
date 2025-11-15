import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/course.controller.dart';
import 'package:client_app/models/course.model.dart';
import 'package:client_app/models/topic.model.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final _courseCtrl = CourseController();

  int _selectedCourseIndex = 0;
  bool _loadingCourses = true;
  bool _loadingTopics = false;
  String? _error;
  List<Course> _courses = [];
  List<Topic> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
      _error = null;
    });

    try {
      final courses = await _courseCtrl.getAllCourses();
      if (!mounted) return;

      setState(() {
        _courses = courses;
        _loadingCourses = false;
      });
      if (_courses.isNotEmpty) {
        _selectedCourseIndex = 0;
        await _loadTopicsForSelectedCourse();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loadingCourses = false;
      });
    }
  }

  Future<void> _loadTopicsForSelectedCourse() async {
    if (_courses.isEmpty) return;

    final course = _courses[_selectedCourseIndex];

    setState(() {
      _loadingTopics = true;
    });

    try {
      final topics = await _courseCtrl.getTopicsByCourse(course.id);
      if (!mounted) return;
      setState(() {
        _topics = topics;
        _loadingTopics = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loadingTopics = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCourses = _courses.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'My Courses',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // TODO: Search nếu cần
              },
              icon: SvgPicture.asset(AppVector.iconSearch),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
             
              SizedBox(
                height: 40,
                child: _buildCourseChips(),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _buildTopicsBody(hasCourses),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildCourseChips() {
  if (_loadingCourses) {
    return const Center(child: CircularProgressIndicator());
  }

  if (_courses.isEmpty) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Chưa có khóa học nào trong Firestore'),
    );
  }

  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: _courses.length,
    separatorBuilder: (_, __) => const SizedBox(width: 12),
    itemBuilder: (context, i) {
      final selected = i == _selectedCourseIndex;
      final courseName = _courses[i].name; // 👈 TÊN KHÓA HỌC TỪ FIREBASE

      return TextButton(
        onPressed: () async {
          setState(() {
            _selectedCourseIndex = i;
          });
          await _loadTopicsForSelectedCourse(); // load topics của course đang chọn
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor:
              selected ? AppColor.buttomSecondCol : Colors.grey,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColor.buttomSecondCol
                : const Color(0xffE8F1FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            courseName, // 👈 HIỂN THỊ TÊN COURSE Ở ĐÂY
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildTopicsBody(bool hasCourses) {
    if (!hasCourses) {
      return const Center(
        child: Text(
          'Hãy tạo ít nhất 1 khóa học trong Firestore (collection "courses")',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_loadingTopics) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _topics.isEmpty) {
      return Center(
        child: Text(
          'Lỗi: $_error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_topics.isEmpty) {
      return const Center(
        child: Text('Khóa học này hiện chưa có topic nào'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTopicsForSelectedCourse,
      child: ListView.separated(
        itemCount: _topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return _topicCard(topic);
        },
      ),
    );
  }

  // ========== CARD HIỂN THỊ 1 TOPIC ==========
  Widget _topicCard(Topic topic) {
    final createdText = topic.createdAt != null
        ? 'Ngày tạo: ${topic.createdAt}'
        : 'Chưa có ngày tạo';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // TODO: Navigate sang màn chi tiết topic nếu bạn muốn
      },
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            // Khung đen bên trái (có thể gắn hình)
            Flexible(
              flex: 1,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                ),
              ),
            ),

            // Nội dung bên phải
            Flexible(
              flex: 2,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
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
                      // tên topic + icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              topic.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColor.buttomThirdCol,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showRemoveBottomSheet(
                                context,
                                message:
                                    "Bạn muốn xóa topic này khỏi khóa học?",
                              );
                            },
                            icon: SvgPicture.asset(AppVector.iconTag),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        createdText,
                        style: TextStyle(
                          color: AppColor.textpriCol,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Chạm để xem chi tiết topic',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
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
    );
  }
}
