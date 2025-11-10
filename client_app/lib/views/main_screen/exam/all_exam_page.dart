import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/detail_exam_page.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AllExamPage extends StatefulWidget {
  const AllExamPage({super.key, required this.courses});

  @override
  State<AllExamPage> createState() => _AllExamPageState();

  final String? courses;
}

class _AllExamPageState extends State<AllExamPage> {
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
                'My Exam',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
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
              SizedBox(height: 20),
              tagLesson(widget.courses ?? 'Khóa học của tôi'),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget tagLesson(String courses) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
         borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailExamPage())),
        child: SizedBox(
          
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
                            Text(
                              courses,
                              style: TextStyle(
                                color: AppColor.buttomThirdCol,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                showRemoveBottomSheet(
                                  context,
                                  // title: 'Lưu thành công',
                                  message: "thành công",
                                );
                              },
                              icon: SvgPicture.asset(AppVector.iconTag),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
