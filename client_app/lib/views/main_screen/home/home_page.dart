import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/data/remote/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không lấy được tên: $e')));
    }
  }

  // ✅ item đang được chọn
  @override
  Widget build(BuildContext context) {
    final title = _loading
        ? 'Hi, ...'
        : 'Hi, ${_displayName.isEmpty ? "User" : _displayName}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              Text(
                'What Would you like to learn Today?\nSearch Below.',
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(color: AppColor.buttonprimaryCol),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                            onPressed: () => setState(() => _selectedIndex = i),
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
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Lesson",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(color: AppColor.buttonprimaryCol),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
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
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Khoa hoc so 2',
                                          style: TextStyle(
                                            color: AppColor.buttomThirdCol,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () => {},
                                          icon: SvgPicture.asset(
                                            AppVector.iconTag,
                                            height: 15,
                                            width: 15,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
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
    );
  }
}
