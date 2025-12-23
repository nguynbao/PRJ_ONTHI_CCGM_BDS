import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoSection extends StatefulWidget {
  final String videoUrl;
  const YoutubeVideoSection({super.key, required this.videoUrl});

  @override
  State<YoutubeVideoSection> createState() => _YoutubeVideoSectionState();
}

class _YoutubeVideoSectionState extends State<YoutubeVideoSection> {
  YoutubePlayerController? _controller;
  bool _isReadyToDisplay = false; // Biến kiểm soát hiển thị

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPlayer();
    });
  }

  void _initPlayer() {
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl.trim());

    debugPrint("===> DEBUG 1: URL = ${widget.videoUrl}");
    debugPrint("===> DEBUG 2: Video ID = $videoId");

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableJavaScript: true,
        playsInline: true,
        strictRelatedVideos: true,
      ),
    );

    // Chờ 400ms để Dialog mở xong hoàn toàn mới bắt đầu render WebView
    // Việc này giúp tránh lỗi "Did not find frame" do tranh chấp tài nguyên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() => _isReadyToDisplay = true);
        }
      });
    });
  }

  @override
  void dispose() {
    // Giải phóng bộ đệm ImageReader ngay lập tức khi đóng Dialog
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_isReadyToDisplay) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(controller: _controller!),
    );
  }
}