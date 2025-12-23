import 'package:url_launcher/url_launcher.dart';

Future<void> openYoutubeExternally(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Không mở được YouTube';
  }
}
