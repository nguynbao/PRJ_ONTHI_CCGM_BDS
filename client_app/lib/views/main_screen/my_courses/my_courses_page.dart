import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/course.controller.dart';
import 'package:client_app/models/course.model.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();

  // Thanh filter phía trên – tạm dùng list cố định
  static const lesson = <String>[
    'Flutter Cơ Bản',
    'Dart OOP & Collections',
    'State Management (Provider)',
    'REST API & JSON',
    'Navigation 2.0',
    'Firebase Auth',
  ];
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final _courseCtrl = CourseController();

  int _selectedIndexLesson = 0;
  bool _loading = true;
  String? _error;
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final data = await _courseCtrl.getAllCourses();
      if (!mounted) return;
      setState(() {
        _courses = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // Icon ĐEN (Android)
          statusBarBrightness: Brightness.light, // Icon ĐEN (iOS)
        ),
        automaticallyImplyLeading: true,
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
                // TODO: mở màn search course
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
              // ====== FILTER HORIZONTAL ======
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MyCoursesPage.lesson.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final selected = i == _selectedIndexLesson;
                    return TextButton(
                      onPressed: () =>
                          setState(() => _selectedIndexLesson = i),
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
                          MyCoursesPage.lesson[i],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey,
                            fontSize: 15,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildCoursesBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Có lỗi xảy ra:\n$_error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_courses.isEmpty) {
      return const Center(
        child: Text(
          'Hiện bạn chưa có khóa học nào',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCourses,
      child: ListView.separated(
        itemCount: _courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final c = _courses[index];
          return _courseCard(c);
        },
      ),
    );
  }

  Widget _courseCard(Course course) {
    final createdText = course.createdAt != null
        ? 'Ngày tạo: ${course.createdAt}'
        : 'Chưa có ngày tạo';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // TODO: điều hướng sang màn topics của course này
        // Navigator.push(...);
      },
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            // Ảnh / thumbnail bên trái
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
                // TODO: bạn có thể cho NetworkImage / AssetImage khóa học ở đây
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
                      // Tên khóa học + icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course.name,
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
                              // Ví dụ: mở bottom sheet hỏi có remove khỏi MyCourses không
                              showRemoveBottomSheet(
                                context,
                                message: "Bạn có muốn xóa khóa học này khỏi My Courses?",
                              );
                            },
                            icon: SvgPicture.asset(AppVector.iconTag),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Topic gợi ý / mô tả (tạm thời)
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
                        'Chạm để xem chi tiết khóa học & topic',
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
