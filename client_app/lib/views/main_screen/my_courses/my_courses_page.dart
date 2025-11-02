import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key, required this.courses, this.topic});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
  static const lesson = <String>[
    'Flutter Cơ Bản',
    'Dart OOP & Collections',
    'State Management (Provider)',
    'REST API & JSON',
    'Navigation 2.0',
    'Firebase Auth',
  ];
  final String? courses;
  final String? topic;
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  int _selectedIndexLesson = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                'My Courses',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                },
                icon: SvgPicture.asset(AppVector.iconSearch),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 40, // đủ chỗ cho padding + chữ
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MyCoursesPage.lesson.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final selected = i == _selectedIndexLesson;
                    return TextButton(
                      onPressed: () => setState(() => _selectedIndexLesson = i),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // bỏ padding mặc định
                        minimumSize: Size.zero, // bỏ min size 88x36
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor:
                            selected // màu ripple
                            ? AppColor.buttomSecondCol
                            : Colors.grey,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          // padding NỘI BỘ
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          // nền item nếu muốn:
                          color: selected
                              ? AppColor.buttomSecondCol
                              : Color(0xffE8F1FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          MyCoursesPage.lesson[i],
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.grey, // tô màu TRỰC TIẾP
                            fontSize: 15,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              tagLesson(widget.courses ?? 'Khóa học của tôi', widget.topic ??'Topic gợi ý'),
            ],
          ),
        ),
      ),
    );
  }

  Widget tagLesson(String courses, String topic) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
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
                    Row(
                      children: [
                        Text(courses, style: TextStyle(color: AppColor.buttomThirdCol, fontWeight: FontWeight.w500),),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            showRemoveBottomSheet(
                              context,
                              // title: 'Lưu thành công',
                              message: "thành công"

                            );
                          },
                          icon: SvgPicture.asset(AppVector.iconTag),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text(topic, style: TextStyle(color: AppColor.textpriCol, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
