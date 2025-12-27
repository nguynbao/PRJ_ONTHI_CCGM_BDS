import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/course.controller.dart';
import 'package:client_app/controllers/user.controller.dart';
import 'package:client_app/models/course.model.dart';
import 'package:client_app/views/main_screen/home/topic_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:client_app/models/topic.model.dart'; // ✅ Đã có import Topic model

class HomePage extends StatefulWidget {
  final void Function()? onOpenDrawer;

  const HomePage({super.key, this.onOpenDrawer});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Biến trạng thái
  int _selectedTopicIndex =
  0; // Index của Chủ đề/Bài học được chọn trong danh sách lọc
  String _displayName = ''; // Tên người dùng hiển thị
  bool _loading = true; // Cờ trạng thái tải dữ liệu

  // Controllers
  final _userCtrl = UserController();
  final _courseCtrl = CourseController();

  // Dữ liệu từ Firebase
  List<Course> _danhSachKhoaHoc = []; // Lưu trữ tất cả Khóa học
  // ✅ THAY ĐỔI: Lưu trữ TOÀN BỘ đối tượng Topic của Khóa học hiện tại
  List<Topic> _tatCaChuDeHienTai = [];

  // Trạng thái cho việc chọn Khóa học
  int _selectedCourseIndex = 0;

  @override
  void initState() {
    super.initState();
    _taiDuLieu();
  }

  Future<void> _taiDuLieu() async {
    setState(() {
      _loading = true;
    });

    try {
      final name = await _userCtrl.getDisplayName();
      final courses = await _courseCtrl.getAllCourses();

      List<Topic> topics = [];
      if (courses.isNotEmpty) {
        final firstCourseId = courses.first.id;
        // Tải Topics cho khóa học đầu tiên
        topics = await _courseCtrl.getTopicsByCourse(firstCourseId);
      }

      if (!mounted) return;

      setState(() {
        _displayName = (name ?? 'Khách').trim();
        _danhSachKhoaHoc = courses;
        _tatCaChuDeHienTai = topics; // ✅ Lưu đối tượng Topic
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        print('Lỗi tải dữ liệu: $e');
      });
    }
  }

  // Hàm tải Topics khi người dùng chọn Khóa học mới
  Future<void> _taiChuDeTheoKhoaHoc(String courseId) async {
    final topics = await _courseCtrl.getTopicsByCourse(courseId);

    if (!mounted) return;

    setState(() {
      _tatCaChuDeHienTai = topics; // ✅ Lưu đối tượng Topic
      _selectedTopicIndex = 0; // Đặt lại index Topic/Bài học
    });
  }

  Widget _buildAppBarContent(BuildContext context, bool isDrawerOpen) {
    final title = _loading
        ? 'Chào, ...'
        : 'Chào, ${_displayName.isEmpty ? "Người dùng" : _displayName}';

    return Row(
      children: [
        IconButton(
          onPressed: widget.onOpenDrawer,
          icon: Icon(
            isDrawerOpen ? Icons.close : Icons.menu,
            color: Colors.black,
            size: 28,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded( // ✅ Thêm Expanded để tránh overflow ngang
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black),
                maxLines: 1, // ✅ Giới hạn dòng
                overflow: TextOverflow.ellipsis, // ✅ Thêm ellipsis nếu quá dài
              ),
              SizedBox(height: 10.h),
              Text(
                'Hôm nay bạn muốn học gì?',
                style: TextStyle(fontSize: 13.sp, color: Colors.black45),
                maxLines: 1, // ✅ Giới hạn dòng
                overflow: TextOverflow.ellipsis, // ✅ Thêm ellipsis nếu quá dài
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    if (_loading && _danhSachKhoaHoc.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (!_loading && _danhSachKhoaHoc.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('Không có Khóa học nào.')),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              "Khóa học",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Xem tất cả',
                style: TextStyle(color: AppColor.buttonprimaryCol),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40.h, // ✅ Tăng height từ 28 lên 40 để phù hợp với minimumSize và tránh overflow
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _danhSachKhoaHoc.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final selected = i == _selectedCourseIndex;
              final course = _danhSachKhoaHoc[i];

              return TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCourseIndex = i;
                  });
                  _taiChuDeTheoKhoaHoc(course.id);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 40),
                  foregroundColor: selected
                      ? AppColor.buttomSecondCol
                      : Colors.grey,
                ),
                child: Center(
                  child: Flexible( // ✅ Thêm Flexible để text có thể wrap hoặc ellipsis
                    child: Text(
                      course.name,
                      style: TextStyle(
                        color: selected ? AppColor.buttomSecondCol : Colors.grey,
                        fontSize: 15.sp, // ✅ Sử dụng .sp để scale theo screen
                      ),
                      maxLines: 1, // ✅ Giới hạn 1 dòng
                      overflow: TextOverflow.ellipsis, // ✅ Ellipsis nếu quá dài
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonSelector() {
    if (_loading) {
      return const SizedBox.shrink(); // Ẩn khi đang tải
    }

    // Tạo danh sách tên Chủ đề duy nhất từ _tatCaChuDeHienTai
    // Ví dụ: ["Topic 1", "Topic 1", "Topic 2"] -> ["Topic 1", "Topic 2"]
    final List<String> tenChuDeDuyNhat = _tatCaChuDeHienTai
        .map((t) => t.name)
        .toSet() // Lấy các phần tử duy nhất
        .toList();

    if (tenChuDeDuyNhat.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Khóa học này chưa có chủ đề.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Chủ đề",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Xem tất cả',
                style: TextStyle(color: AppColor.buttonprimaryCol),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40.h, // ✅ Tăng height từ 28 lên 40 để phù hợp với minimumSize và tránh overflow
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tenChuDeDuyNhat.length, // ✅ Dùng danh sách tên DUY NHẤT
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final selected = i == _selectedTopicIndex;
              final topicName = tenChuDeDuyNhat[i]; // Tên Chủ đề duy nhất

              return TextButton(
                onPressed: () => setState(() => _selectedTopicIndex = i),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 40),
                  foregroundColor: selected
                      ? AppColor.buttomSecondCol
                      : Colors.grey,
                ),
                child: Center(
                  child: Flexible( // ✅ Thêm Flexible để text có thể wrap hoặc ellipsis
                    child: Text(
                      topicName, // Hiển thị tên Topic
                      style: TextStyle(
                        color: selected ? AppColor.buttomSecondCol : Colors.grey,
                        fontSize: 15.sp, // ✅ Sử dụng .sp để scale theo screen
                      ),
                      maxLines: 1, // ✅ Giới hạn 1 dòng
                      overflow: TextOverflow.ellipsis, // ✅ Ellipsis nếu quá dài
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard({
    required String courseName,
    required String topicName,
    required void Function() onTap,
  }) {
    return SizedBox(
      height: 250.h,
      width: 250.w,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Phần hình ảnh)
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
            ),

            Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            courseName,
                            style: TextStyle(
                              color: AppColor.buttomThirdCol,
                              fontSize: 14.sp, // ✅ Sử dụng .sp và giảm nhẹ nếu cần
                            ),
                            maxLines: 1, // ✅ Giới hạn dòng
                            overflow: TextOverflow.ellipsis, // ✅ Ellipsis nếu quá dài
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => {},
                            icon: SvgPicture.asset(
                              AppVector.iconTag,
                              height: 15,
                              width: 15,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Flexible( // ✅ Thêm Flexible để text có thể thu nhỏ nếu cần
                        child: Text(
                          topicName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp, // ✅ Sử dụng .sp
                          ),
                          maxLines: 2, // ✅ Cho phép 2 dòng để linh hoạt hơn
                          overflow: TextOverflow.ellipsis, // ✅ Ellipsis nếu quá dài
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

  Widget _buildFeatureBanner() => Container(
    height: 180.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColor.buttonprimaryCol,
      borderRadius: BorderRadius.all(Radius.circular(15.r)),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
    ),
    child: Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: Opacity(
            opacity: 0.2,
            child: SvgPicture.asset(
              AppVector.iconTag,
              height: 100.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible( // ✅ Thêm Flexible cho text dài
                child: Text(
                  'Khóa học ưu đãi hôm nay!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8.h),
              Flexible( // ✅ Thêm Flexible cho text dài
                child: Text(
                  'Flutter Developer Pro\nGiảm 50%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttomSecondCol,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Xem ngay',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    final bool isDrawerOpen = scaffold?.isDrawerOpen ?? false;

    // 1. Xác định tên Khóa học cha
    final String currentCourseName = _danhSachKhoaHoc.isNotEmpty
        ? _danhSachKhoaHoc[_selectedCourseIndex].name
        : 'Không có Khóa học';

    // 2. Lấy danh sách TÊN Chủ đề DUY NHẤT để tìm Tên Chủ đề được chọn
    final List<String> tenChuDeDuyNhat = _tatCaChuDeHienTai
        .map((t) => t.name)
        .toSet()
        .toList();

    // 3. Xác định Tên Chủ đề đang được chọn (dựa trên index của danh sách TÊN DUY NHẤT)
    final String tenChuDeDuocChon =
    tenChuDeDuyNhat.isNotEmpty &&
        _selectedTopicIndex < tenChuDeDuyNhat.length
        ? tenChuDeDuyNhat[_selectedTopicIndex]
        : '';

    // 4. LỌC danh sách TẤT CẢ Chủ đề để chỉ lấy những Chủ đề có tên khớp
    final List<Topic> chuDeDaLoc = _tatCaChuDeHienTai
        .where((topic) => topic.name == tenChuDeDuocChon)
        .toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 100.h,
          title: _buildAppBarContent(context, isDrawerOpen),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh trái
                children: [
                  _buildFeatureBanner(),

                  const SizedBox(height: 10),
                  _buildCategorySelector(),

                  const SizedBox(height: 20),
                  _buildLessonSelector(),

                  const SizedBox(height: 20),

                  // HIỂN THỊ DANH SÁCH THẺ ĐÃ LỌC
                  if (chuDeDaLoc.isEmpty && !_loading)
                    const Text(
                      'Không có nội dung cho chủ đề đã chọn.',
                      style: TextStyle(color: Colors.grey),
                    ),

                  if (chuDeDaLoc.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 250.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            chuDeDaLoc.length, // ✅ Dùng danh sách ĐÃ LỌC
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 20.w),
                            itemBuilder: (context, index) {
                              final topicDaLoc = chuDeDaLoc[index];

                              return _buildCourseCard(
                                courseName: currentCourseName,
                                topicName:
                                topicDaLoc.name, // Lấy tên từ Topic đã lọc
                                onTap: () {
                                  // ✅ SỬA LỖI: Sử dụng _selectedCourseIndex thay vì index
                                  final course = _danhSachKhoaHoc[_selectedCourseIndex];
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => TopicDetailPage(
                                        courseId: course.id,
                                        topicId: topicDaLoc.id,
                                        topicName: topicDaLoc.name,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}