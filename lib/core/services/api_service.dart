import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../constants/constants.dart';

class ADASApiService {
  static const _base    = AppConstants.adasBaseUrl;
  static const _timeout = AppConstants.uploadTimeout;

  static Map<String, String> _headers() => {
    'Authorization': 'Bearer ${AuthService.accessToken ?? ""}',
  };

  // ── Build full video URL from relative path ────────────────────────────────
  static String buildVideoUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$_base$path';
  }

  static String dashcamResultUrl(String jobId) =>
      '$_base/api/mobile/video/download/$jobId/result.mp4';

  static String driverResultUrl(String jobId) =>
      '$_base/api/mobile/driver/download/$jobId/result.mp4';

  // ── Upload dashcam video ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>> uploadDashcam(File video) async {
    final uri = Uri.parse('$_base/api/mobile/video/upload');
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers())
      ..files.add(await http.MultipartFile.fromPath('file', video.path))
      ..fields['video_type'] = 'dashcam'
      ..fields['device']     = 'cuda';

    final streamed = await req.send().timeout(_timeout);
    final res = await http.Response.fromStream(streamed);
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Get dashcam job status ────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getDashcamStatus(String jobId) async {
    final res = await http
        .get(Uri.parse('$_base/api/mobile/video/status/$jobId'),
            headers: _headers())
        .timeout(_timeout);
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Upload driver video ───────────────────────────────────────────────────
  static Future<Map<String, dynamic>> uploadDriver(File video) async {
    final uri = Uri.parse('$_base/api/mobile/driver/upload');
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers())
      ..files.add(await http.MultipartFile.fromPath('file', video.path));

    final streamed = await req.send().timeout(_timeout);
    final res = await http.Response.fromStream(streamed);
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Get driver job status ─────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getDriverStatus(String jobId) async {
    final res = await http
        .get(Uri.parse('$_base/api/mobile/driver/status/$jobId'),
            headers: _headers())
        .timeout(_timeout);
    _checkStatus(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static void _checkStatus(http.Response res) {
    if (res.statusCode >= 400) {
      throw 'Lỗi API ${res.statusCode}: ${res.body}';
    }
  }
}
