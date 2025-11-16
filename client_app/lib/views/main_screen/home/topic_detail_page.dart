// TopicDetailPage.dart
import 'package:client_app/controllers/course.controller.dart';
import 'package:client_app/models/topic.model.dart';
import 'package:flutter/material.dart';

class TopicDetailPage extends StatefulWidget {
  final String topicId;
  final String topicName;
  final String courseId; // Cần thiết
  
  const TopicDetailPage({
    super.key, 
    required this.topicId, 
    required this.topicName,
    required this.courseId, 
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  
  List<MapEntry<String, dynamic>> _docEntries = []; 
  bool _isLoading = true;
  final CourseController _courseController = CourseController();
 
  @override
  void initState() {
    super.initState();
    _loadTopicData();
  }

  // Phương thức tải toàn bộ Document Topic
  Future<void> _loadTopicData() async {
    try {
      // Sử dụng phương thức Controller để tải toàn bộ Topic
      final Topic? topic = await _courseController.getTopicDocument(
        courseId: widget.courseId, 
        topicId: widget.topicId
      );
      
      if(mounted) {
        if (topic != null) {
          // CHUYỂN ĐỔI: Chuyển Map thành List<MapEntry> để dễ dàng lặp qua
          setState(() {
            _docEntries = topic.doc.entries.toList(); 
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Lỗi tải dữ liệu Topic: $e');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicName, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : _docEntries.isEmpty
                ? const Center(child: Text("Không có nội dung chi tiết cho chủ đề này."))
                : Container(
                  decoration: BoxDecoration(
                    color: Color(0xffE2E6EA),
                  ),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _docEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _docEntries[index];
                        final title = entry.key; 
                        final content = entry.value?.toString() ?? "Nội dung trống";                     
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title, 
                                    style: TextStyle(
                                      color: Colors.black, 
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    content, 
                                    style: TextStyle(
                                      color: Colors.black54, 
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ),
      ),
    );
  }
}