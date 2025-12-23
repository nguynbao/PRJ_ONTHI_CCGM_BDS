// exam_history_page.dart
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/exam.controller.dart';
import 'package:client_app/models/exam_history.model.dart';
import 'package:flutter/material.dart';

class ExamHistoryPage extends StatelessWidget {
  final String examId;
  final String examName;

  ExamHistoryPage({super.key, required this.examId, required this.examName});

  // Khởi tạo Controller
  final ExamController _controller = ExamController(); // Đảm bảo constructor là const nếu không có tham số

  // Hàm phụ trợ để định dạng thời gian làm bài
  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes phút $seconds giây';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử làm bài: $examName',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColor.buttonprimaryCol,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<ExamHistory>>(
        // 🔥 Lấy lịch sử làm bài theo UID của người dùng hiện tại và examId
        stream: _controller.getExamHistoryStream(examId: examId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Kiểm tra lỗi nếu người dùng chưa đăng nhập
            if (snapshot.error.toString().contains('User not logged in')) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text('Vui lòng đăng nhập để xem lịch sử làm bài.', textAlign: TextAlign.center),
                ),
              );
            }
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
          }

          final historyList = snapshot.data ?? [];

          if (historyList.isEmpty) {
            return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Bạn chưa làm bài thi này lần nào. Hãy bắt đầu làm bài để xem lại kết quả!',
                    textAlign: TextAlign.center,
                  ),
                ));
          }

          // 🔥 Hiển thị danh sách lịch sử làm bài
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final history = historyList[index];
              return _buildHistoryCard(context, history, index, historyList);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ExamHistory history, int index, List<ExamHistory> historyList) {
    final double percentage = history.totalQuestions > 0 ? (history.correctCount / history.totalQuestions) * 100 : 0;
    final bool isPassed = percentage >= 50; // Giả định qua bài là 50%
    final Color scoreColor = isPassed ? Colors.green.shade700 : Colors.red.shade700;
    final String statusText = isPassed ? 'Hoàn thành' : 'Chưa đạt';

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: scoreColor,
          child: Text(
            '${percentage.round()}%',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lần làm bài #${historyList.length - index}', // Đếm ngược để lần mới nhất ở trên
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: scoreColor, width: 1),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đúng: ${history.correctCount}/${history.totalQuestions} câu',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Thời gian: ${_formatTime(history.timeTakenSeconds)}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Ngày làm: ${history.submissionTime.day}/${history.submissionTime.month}/${history.submissionTime.year} lúc ${history.submissionTime.hour}:${history.submissionTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.history_toggle_off_rounded, color: AppColor.buttonprimaryCol),
          onPressed: () {
            // TODO: Điều hướng đến trang ReviewExamPage với kết quả lịch sử
            // Điều này yêu cầu lưu trữ chi tiết answers/choices cho từng lần làm bài
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng xem lại chi tiết bài làm đang được phát triển!'))
            );
          },
        ),
      ),
    );
  }
}