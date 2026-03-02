import 'dart:io';
import 'package:flutter/material.dart';
import '../core/models/driver_models.dart';
import '../core/services/api_service.dart';

enum DriverAnalysisState { idle, uploading, processing, completed, failed }

class DriverMonitoringProvider extends ChangeNotifier {
  DriverAnalysisState     _state     = DriverAnalysisState.idle;
  double                  _progress  = 0;
  String                  _statusMsg = '';
  DriverMonitoringResult? _result;
  String?                 _errorMsg;

  DriverAnalysisState     get state     => _state;
  double                  get progress  => _progress;
  String                  get statusMsg => _statusMsg;
  DriverMonitoringResult? get result    => _result;
  String?                 get errorMsg  => _errorMsg;

  void reset() {
    _state = DriverAnalysisState.idle; _progress = 0;
    _statusMsg = ''; _result = null; _errorMsg = null;
    notifyListeners();
  }

  Future<void> analyzeVideo(File video) async {
    _state = DriverAnalysisState.uploading;
    _progress = 0; _errorMsg = null; _result = null;
    _statusMsg = 'Đang tải video lên...';
    notifyListeners();

    try {
      final uploadData = await ADASApiService.uploadDriver(video);
      final upload = DriverUploadResponse.fromJson(uploadData);
      if (upload.jobId.isEmpty) throw 'Không nhận được job ID';

      _state = DriverAnalysisState.processing;
      _statusMsg = 'Đang chờ xử lý...';
      notifyListeners();

      await _poll(upload.jobId);
    } catch (e) {
      _state    = DriverAnalysisState.failed;
      _errorMsg = e.toString();
      _progress = 0;
      notifyListeners();
    }
  }

  Future<void> _poll(String jobId) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      final data = await ADASApiService.getDriverStatus(jobId);
      final job  = DriverStatusResponse.fromJson(data);

      _progress = job.progressPercent / 100.0;

      switch (job.status) {
        case 'completed':
          final r   = job.result;
          final raw = r?.videoUrl ?? r?.downloadUrl;
          final url = raw != null
              ? ADASApiService.buildVideoUrl(raw)
              : ADASApiService.driverResultUrl(jobId);
          if (r != null) {
            _result = DriverMonitoringResult.fromData(r, url);
          }
          _state     = DriverAnalysisState.completed;
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
