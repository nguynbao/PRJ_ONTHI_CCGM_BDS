import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewExamPage extends StatefulWidget {
  const ReviewExamPage({super.key});

  @override
  State<ReviewExamPage> createState() => _ReviewExamPageState();
}

class _ReviewExamPageState extends State<ReviewExamPage> {
  int selectedAnswerIndex = -1;
  List<String?> userSelections = [
    'B',
    null,
    'A',
    'D',
    'C',
    null,
    null,
    'B',
    'A',
    null,
  ];
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
            Align(
              alignment: Alignment.center,
              child: Text(
                "Xem kết quả",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            InkWell(onTap: () {}, child: Image.asset(AppIcons.imgCheck)),
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Câu số 1:",
                        style: TextStyle(
                          color: AppColor.primaryBlue,
                          fontSize: 17,
                        ),
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
                      boxAnswer("A", 'Nội dung đáp án A', 0), // Index 0
                      boxAnswer("B", 'Nội dung đáp án B', 1), // Index 1
                      boxAnswer("C", 'Nội dung đáp án C', 2), // Index 2
                      boxAnswer("D", 'Nội dung đáp án D', 3), //
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back, size: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showListAnswerBottomSheet(context, 10, 0, 3, userSelections);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.buttonprimaryCol,
                  ),
                  child: Text(
                    "Danh sách câu hỏi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget boxAnswer(
    String list,
    String answer,
    int index, // Thêm index để xác định đáp án nào được gọi
  ) {
    // Logic xác định trạng thái chọn
    final bool isSelected = selectedAnswerIndex == index;

    final containerColor = isSelected
        ? AppColor.buttonprimaryCol
        : Colors.white;
    final circleColor = isSelected
        ? Colors
              .white // Thay đổi màu nền vòng tròn khi chọn (ví dụ)
        : AppColor.primaryBlue;
    final listTextColor = isSelected
        ? AppColor.buttonprimaryCol
        : Colors.white; // Thay đổi màu chữ trong vòng tròn
    final answerTextColor = isSelected ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        // Cập nhật trạng thái khi người dùng chọn
        setState(() {
          selectedAnswerIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: AppColor.buttonprimaryCol, width: 2)
                : null, // Thêm viền khi chọn
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
                Container(
                  width: 40.h, // Đặt kích thước cố định cho vòng tròn
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    list,
                    style: TextStyle(
                      color: listTextColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // Sử dụng Expanded để đảm bảo Text không bị tràn nếu câu trả lời dài
                Expanded(
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: answerTextColor,
                      fontSize: 19.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
