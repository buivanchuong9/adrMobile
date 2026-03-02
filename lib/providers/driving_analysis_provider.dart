import 'dart:io';
import 'package:flutter/material.dart';
import '../core/models/analysis_models.dart';
import '../core/services/api_service.dart';

enum AnalysisState { idle, uploading, processing, completed, failed }

class DrivingAnalysisProvider extends ChangeNotifier {
  AnalysisState _state       = AnalysisState.idle;
  double        _progress    = 0;
  String        _statusMsg   = '';
  AnalysisResult? _result;
  String? _errorMsg;

  AnalysisState  get state     => _state;
  double         get progress  => _progress;
  String         get statusMsg => _statusMsg;
  AnalysisResult? get result   => _result;
  String?        get errorMsg  => _errorMsg;

  void reset() {
    _state = AnalysisState.idle; _progress = 0;
    _statusMsg = ''; _result = null; _errorMsg = null;
    notifyListeners();
  }

  Future<void> analyzeVideo(File video) async {
    _state = AnalysisState.uploading;
    _progress = 0; _errorMsg = null; _result = null;
    _statusMsg = 'Đang tải video lên...';
    notifyListeners();

    try {
      // Upload
      final uploadData = await ADASApiService.uploadDashcam(video);
      final upload = UploadResponse.fromJson(uploadData);
      if (upload.jobId.isEmpty) throw 'Không nhận được job ID';

      _state = AnalysisState.processing;
      _statusMsg = 'Đang chờ xử lý...';
      notifyListeners();

      // Poll every 2 seconds
      await _poll(upload.jobId);
    } catch (e) {
      _state    = AnalysisState.failed;
      _errorMsg = e.toString();
      _progress = 0;
      notifyListeners();
    }
  }

  Future<void> _poll(String jobId) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      final data = await ADASApiService.getDashcamStatus(jobId);
      final job  = JobStatusResponse.fromJson(data);

      _progress = job.progressPercent / 100.0;

      switch (job.status) {
        case 'completed':
          final r = job.result;
          final metrics = r?.analysis;
          final rawUrl  = r?.videoUrl ?? r?.downloadUrl;
          final url = rawUrl != null ? ADASApiService.buildVideoUrl(rawUrl) : ADASApiService.dashcamResultUrl(jobId);
          _result = AnalysisResult(
            resultVideoUrl:      url,
            safetyScore:         r?.safetyScore ?? 0,
            carsDetected:        metrics?.carsDetected ?? 0,
            pedestriansDetected: metrics?.pedestriansDetected ?? 0,
            warningsCount:       metrics?.warningsCount ?? 0,
            laneDepartures:      metrics?.laneDepartures ?? 0,
            events:              metrics?.events ?? [],
          );
          _state     = AnalysisState.completed;
          _statusMsg = 'Phân tích hoàn tất!';
          notifyListeners();
          return;

        case 'failed':
          throw job.errorMessage ?? 'Phân tích thất bại';

        case 'processing':
          _statusMsg = 'Đang phân tích... ${(_progress * 100).round()}%';

        default:
          _statusMsg = 'Đang chờ xử lý...';
      }
      notifyListeners();
    }
  }
}
