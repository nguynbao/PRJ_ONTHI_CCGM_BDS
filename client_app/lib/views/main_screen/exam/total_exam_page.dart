import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/exam/exam_page.dart';
import 'package:client_app/views/main_screen/exam/inside_exam_page.dart';
import 'package:client_app/views/main_screen/exam/review_exam_page.dart';
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TotalExamPage extends StatelessWidget {
  const TotalExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD9D9D9),
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (Route<dynamic> route) => false,
                ),
              },
              icon: Image.asset(AppIcons.imgBack),
            ),
            Spacer(),
            Text(
              "Topic số 1",

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
          ],
        ),
        backgroundColor: AppColor.buttonprimaryCol,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(30, 30, 30, 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          box(
                            AppIcons.imgBook,
                            '10',
                            'Câu hỏi',
                            AppColor.buttonprimaryCol,
                          ),
                          box(
                            AppIcons.imgTime,
                            '15',
                            'Thời gian',
                            AppColor.buttomThirdCol,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 320.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              spreadRadius: 0,
                              color: Colors.black38,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item(
                              AppIcons.imgLich,
                              'Ngày hoàn thành',
                              '30/09/2025',
                              AppColor.buttonprimaryCol,
                            ),
                            item(
                              AppIcons.imgLich,
                              'Số điểm',
                              '10/10',
                              AppColor.buttomSecondCol,
                            ),
                            SizedBox(height: 15.h),
                            Divider(thickness: 0.2, indent: 30, endIndent: 30),
                            item(
                              AppIcons.imgStar,
                              'Đánh giá',
                              '',
                              AppColor.buttomThirdCol,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ElevatedButton(
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (_)=> const ReviewExamPage()))},
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.buttonprimaryCol,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Xem lại bài kiểm tra",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget box(icon, String num, String title, Color color) {
    return Container(
      height: 150,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 8),
            color: Colors.black38,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              widthFactor: 1,
              child: Container(
                // width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                      color: Colors.black38,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(icon, height: 60, width: 60),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      num,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(icon, String title, String content, Color color) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 30.h, vertical: 15.w),
      child: Row(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(icon, height: 40, width: 40),
          ),
          SizedBox(width: 15.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.black38,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
