import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/data/remote/user_service.dart';
import 'package:client_app/views/main_screen/exam/all_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
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

  @override
  Widget build(BuildContext context) {
    final title = _loading
        ? 'Hi, ...'
        : 'Hi, ${_displayName.isEmpty ? "User" : _displayName}';
    return Scaffold(
      
      appBar: AppBar(
         systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // Icon ĐEN (Android)
          statusBarBrightness: Brightness.light,  // Icon ĐEN (iOS)
        ),
      
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: tagLesson(
                          'Khoá học số 2',
                          'Topic 1',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllExamPage(courses: '',)));
                            print('1');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 250,
                        child: tagLesson(
                          'Khoá học số 1',
                          'Topic 2',
                          onTap: () {
                            print("2");
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 250,
                        child: tagLesson(
                          'Khoá học số 3',
                          'Topic 3',
                          onTap: () {
                            print('3');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                // flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Thống kê tuần này",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          boxView(
                            AppColor.buttonprimaryCol,
                            AppVector.iconDone,
                            "Bài tập\nĐã làm",
                          ),
                          boxView(
                            AppColor.buttomSecondCol,
                            AppVector.iconQuestion,
                            "Câu hỏi\nĐã làm",
                          ),
                          boxView(
                            AppColor.buttomThirdCol,
                            AppVector.iconOclock,
                            "Thời gian\n  Đã làm",
                            size: 30
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget boxView(Color? color, String icon, String text, {double? size}) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SvgPicture.asset(icon, width: size ?? 24, height: size ?? 24,),
            SizedBox(height: 10),
            Text("0"),
            SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget tagLesson(String courses, String topic, {VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // tăng vùng chạm
      onTap: onTap,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          courses,
                          style: TextStyle(
                            color: AppColor.buttomThirdCol,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(AppVector.iconTag),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      topic,
                      style: TextStyle(
                        color: AppColor.textpriCol,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
