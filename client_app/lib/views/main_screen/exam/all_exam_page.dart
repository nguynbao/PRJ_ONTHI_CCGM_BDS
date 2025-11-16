import 'package:client_app/config/assets/app_vectors.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/exam.controller.dart';
import 'package:client_app/models/exam.model.dart';
import 'package:client_app/views/main_screen/exam/detail_exam_page.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AllExamPage extends StatefulWidget {
  const AllExamPage({super.key,  required this.courseId, });

  @override
  State<AllExamPage> createState() => _AllExamPageState();

  final String courseId;
}

class _AllExamPageState extends State<AllExamPage> {
  final ExamController _examCtrl = ExamController();
  List<Exam> _examList = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadExams();
  }
  Future<void> _loadExams() async {
    try {
      // ✅ Sử dụng courseId để tải tất cả Exams
      final exams = await _examCtrl.getExamsByCourse(widget.courseId);

      if (mounted) {
        setState(() {
          _examList = exams;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Lỗi tải danh sách bài thi: $e");
    }
  }
  
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
             _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _examList.isEmpty
                      ? const Center(child: Text('Khóa học này chưa có bộ đề nào.'))                      
                      : Expanded( 
                          child: ListView.builder(
                            itemCount: _examList.length,
                            itemBuilder: (context, index) {
                              final exam = _examList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: tagLesson(
                                  exam.name, 
                                  examId: exam.id,
                                ),
                              );
                            },
                          ),
                        ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget tagLesson(String examName, {required String examId}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
         borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) => DetailExamPage(
              examId: examId, 
              examName: examName,
            )
          )
        ),
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
                              examName,
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
                                  message: "Thao tác thành công",
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
