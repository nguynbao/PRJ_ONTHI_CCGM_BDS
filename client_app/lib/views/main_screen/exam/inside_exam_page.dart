import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsideExamPage extends StatelessWidget {
  const InsideExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD9D9D9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Image.asset(AppIcons.imgBack),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Thời gian",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            IconButton(onPressed: () => {}, icon: Icon(Icons.done)),
          ],
        ),
        backgroundColor: AppColor.buttonprimaryCol,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Câu số 1:",
                    style: TextStyle(color: AppColor.primaryBlue, fontSize: 17),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black38,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border(
                        left: BorderSide(
                          color: AppColor.buttonprimaryCol,
                          width: 6,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  boxAnswer("A", 'ádasdasdadas'),
                  boxAnswer("B", 'ádasdasdadas'),
                  boxAnswer("C", 'ádasdasdadas'),
                  boxAnswer("D", 'ádasdasdadas'),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle
                ),
                child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back, size: 20))),
              ElevatedButton(
                onPressed: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.buttonprimaryCol,
                  ),
                  child: Text("Danh sách câu hỏi", style: TextStyle(color: Colors.white),),
                ),
              ),
              Container(
                 decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle
                ),
                child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward, size: 20,))),
            ],
          ),
        ),
      ),
    );
  }

  Widget boxAnswer(String list, String answer) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black38,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.h),
                    child: Text(
                      list,
                      style: TextStyle(
                        color: AppColor.buttonprimaryCol,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Text(
                answer,
                style: TextStyle(color: Colors.black, fontSize: 19.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
