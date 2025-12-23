import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // DEV
      ),
    );

    await _remoteConfig.setDefaults({
      'show_video_ad': false,
      'tiktok_video_mp4_url': '',
      'tiktok_open_url': '',
    });

    await _remoteConfig.fetchAndActivate();
  }

  bool get showAd => _remoteConfig.getBool('show_video_ad');
  String get videoUrl => _remoteConfig.getString('tiktok_video_mp4_url');
  String get openUrl => _remoteConfig.getString('tiktok_open_url');
}
