import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/data/remote/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  // Thay đổi: onOpenDrawer là nullable (dùng dấu ?) và không cần 'required'
  final void Function()? onOpenDrawer;

  // Thay đổi: Bỏ 'required'
  const HomePage({super.key, this.onOpenDrawer});

  static const categories = <String>[
    'Flutter',
    'Dart',
    'State',
    'API',
    'Firebase',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
    'UI/UX',
  ];
  static const lesson = <String>[
    'Flutter Cơ Bản',
    'Dart OOP & Collections',
    'State Management (Provider)',
    'REST API & JSON',
    'Navigation 2.0',
    'Firebase Auth',
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedIndexLesson = 0;
  final _userSvc = UserService();
  String _displayName = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final name = await _userSvc.getDisplayName();
      if (!mounted) return;
      setState(() {
        _displayName = (name ?? '').trim();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      // Sử dụng `mounted` để tránh lỗi khi `context` không còn tồn tại
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không lấy được tên: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lưu ý: Scaffold.of(context) cần được đặt trong widget con của Scaffold
    // Ở đây, HomePage đang return Scaffold, nhưng chúng ta cần Scaffold của HomeContainer
    // Nếu HomePage được sử dụng bên trong một Scaffold khác, nó sẽ hoạt động.
    final bool isDrawerOpen = Scaffold.of(context).isDrawerOpen;

    final title = _loading
        ? 'Hi, ...'
        : 'Hi, ${_displayName.isEmpty ? "User" : _displayName}';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark, // Icon ĐEN (Android)
            statusBarBrightness: Brightness.light, // Icon ĐEN (iOS)
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 100.h,
          title: Row(
            children: [
              IconButton(
                // Gọi callback tùy chọn, nếu null thì không làm gì
                onPressed: widget.onOpenDrawer,
                icon: Icon(
                  // *** THAY ĐỔI LỚN NHẤT: Kiểm tra trạng thái Drawer
                  isDrawerOpen ? Icons.close : Icons.menu,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.black)),
                  SizedBox(height: 10.h),
                  Text(
                    'What Would you like to learn Today?\nSearch Below.',
                    style: TextStyle(fontSize: 13.sp, color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Container(
                  //   height: 200,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //     borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  //   ),
                  // ),
                  _buildFeatureBanner(),

                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Categories",
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
                              'See All',
                              style: TextStyle(
                                color: AppColor.buttonprimaryCol,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 28,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal, // ✅ cuộn ngang
                          itemCount: HomePage.categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12), // ✅ khoảng cách ngang
                          itemBuilder: (context, i) {
                            final selected = i == _selectedIndex;
                            return TextButton(
                              onPressed: () =>
                                  setState(() => _selectedIndex = i),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                minimumSize: const Size(0, 40),
                                foregroundColor: selected
                                    ? AppColor.buttomSecondCol
                                    : Colors.grey, // ripple
                              ),
                              child: Center(
                                child: Text(
                                  HomePage.categories[i],
                                  style: TextStyle(
                                    color: selected
                                        ? AppColor.buttomSecondCol
                                        : Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );

                            // Gợi ý nâng cấp UI: dùng Chip
                            // return Chip(
                            //   label: Text(categories[i]),
                            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Lesson",
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
                              'See All',
                              style: TextStyle(
                                color: AppColor.buttonprimaryCol,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 28,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal, // ✅ cuộn ngang
                          itemCount: HomePage.lesson.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12), // ✅ khoảng cách ngang
                          itemBuilder: (context, i) {
                            final selected = i == _selectedIndexLesson;
                            return TextButton(
                              onPressed: () =>
                                  setState(() => _selectedIndexLesson = i),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                minimumSize: const Size(0, 40),
                                foregroundColor: selected
                                    ? AppColor.buttomSecondCol
                                    : Colors.grey, // ripple
                              ),
                              child: Center(
                                child: Text(
                                  HomePage.lesson[i],
                                  style: TextStyle(
                                    color: selected
                                        ? AppColor.buttomSecondCol
                                        : Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );

                            // Gợi ý nâng cấp UI: dùng Chip
                            // return Chip(
                            //   label: Text(categories[i]),
                            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 250.h,
                        width: 250.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Khoa hoc so 2',
                                            style: TextStyle(
                                              color: AppColor.buttomThirdCol,
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () => {},
                                            icon: SvgPicture.asset(
                                              AppVector.iconTag,
                                              height: 15,
                                              width: 15,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    Colors.black,
                                                    BlendMode.srcIn,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Text(
                                        "Topic so 1",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
              Text(
                'Khóa học ưu đãi hôm nay!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Flutter Developer Pro\nGiảm 50%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
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
}
