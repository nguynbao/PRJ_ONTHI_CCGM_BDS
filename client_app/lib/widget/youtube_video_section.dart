import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoSection extends StatefulWidget {
  final String videoUrl;
  const YoutubeVideoSection({super.key, required this.videoUrl});

  @override
  State<YoutubeVideoSection> createState() => _YoutubeVideoSectionState();
}

class _YoutubeVideoSectionState extends State<YoutubeVideoSection> {
  late YoutubePlayerController _controller;
  bool _isValidVideo = true;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId == null || videoId.isEmpty) {
      _isValidVideo = false;
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    if (_isValidVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidVideo) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("Không phát được video"),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
