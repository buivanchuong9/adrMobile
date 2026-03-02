// ── Upload Response ───────────────────────────────────────────────────────────
class UploadResponse {
  final bool?   success;
  final String  jobId;
  final String  status;
  final String? message;
  final String? videoType;
  final int?    estimatedTimeSec;
  final String? createdAt;

  const UploadResponse({
    this.success, required this.jobId, required this.status,
    this.message, this.videoType, this.estimatedTimeSec, this.createdAt,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> j) => UploadResponse(
    success:          j['success'] as bool?,
    jobId:            j['job_id']  as String? ?? '',
    status:           j['status']  as String? ?? '',
    message:          j['message'] as String?,
    videoType:        j['video_type'] as String?,
    estimatedTimeSec: j['estimated_time_seconds'] as int?,
    createdAt:        j['created_at'] as String?,
  );
}

// ── Job Status Response ──────────────────────────────────────────────────────
class JobStatusResponse {
  final bool?              success;
  final String             jobId;
  final String             status;       // pending|processing|completed|failed
  final int                progressPercent;
  final String?            videoType;
  final AnalysisResultData? result;
  final String?            errorMessage;

  const JobStatusResponse({
    this.success, required this.jobId, required this.status,
    required this.progressPercent, this.videoType, this.result, this.errorMessage,
  });

  factory JobStatusResponse.fromJson(Map<String, dynamic> j) {
    final res  = j['result'];
    final err  = j['error'];
    return JobStatusResponse(
      success:         j['success'] as bool?,
      jobId:           j['job_id']  as String? ?? '',
      status:          j['status']  as String? ?? '',
      progressPercent: j['progress_percent'] as int? ?? 0,
      videoType:       j['video_type'] as String?,
      result: res != null ? AnalysisResultData.fromJson(res as Map<String, dynamic>) : null,
      errorMessage: err is Map ? err['message'] as String? : null,
    );
  }
}

// ── Analysis Result Data ─────────────────────────────────────────────────────
class AnalysisResultData {
  final String? videoUrl;
  final String? downloadUrl;
  final String? thumbnailUrl;
  final int?    safetyScore;
  final double? durationSeconds;
  final double? processingTimeSec;
  final AnalysisMetrics? analysis;

  const AnalysisResultData({
    this.videoUrl, this.downloadUrl, this.thumbnailUrl, this.safetyScore,
    this.durationSeconds, this.processingTimeSec, this.analysis,
  });

  factory AnalysisResultData.fromJson(Map<String, dynamic> j) => AnalysisResultData(
    videoUrl:         j['video_url']    as String?,
    downloadUrl:      j['download_url'] as String?,
    thumbnailUrl:     j['thumbnail_url'] as String?,
    safetyScore:      j['safety_score'] as int?,
    durationSeconds:  (j['duration_seconds'] as num?)?.toDouble(),
    processingTimeSec:(j['processing_time_seconds'] as num?)?.toDouble(),
    analysis: j['analysis'] != null
        ? AnalysisMetrics.fromJson(j['analysis'] as Map<String, dynamic>)
        : null,
  );
}

// ── Analysis Metrics ─────────────────────────────────────────────────────────
class AnalysisMetrics {
  final int? carsDetected;
  final int? pedestriansDetected;
  final int? laneDepartures;
  final int? warningsCount;
  final List<AnalysisEventData> events;

  const AnalysisMetrics({
    this.carsDetected, this.pedestriansDetected,
    this.laneDepartures, this.warningsCount, this.events = const [],
  });

  factory AnalysisMetrics.fromJson(Map<String, dynamic> j) => AnalysisMetrics(
    carsDetected:          j['cars_detected']         as int?,
    pedestriansDetected:   j['pedestrians_detected']  as int?,
    laneDepartures:        j['lane_departures']        as int?,
    warningsCount:         j['warnings_count']         as int?,
    events: (j['events'] as List<dynamic>? ?? [])
        .map((e) => AnalysisEventData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

// ── Analysis Event ────────────────────────────────────────────────────────────
class AnalysisEventData {
  final String type;
  final String timestamp;
  final String severity; // low | medium | high

  const AnalysisEventData({
    required this.type, required this.timestamp, required this.severity});

  factory AnalysisEventData.fromJson(Map<String, dynamic> j) => AnalysisEventData(
    type:      j['type']      as String? ?? '',
    timestamp: j['timestamp'] as String? ?? '',
    severity:  j['severity']  as String? ?? 'low',
  );
}

// ── App-level result ─────────────────────────────────────────────────────────
class AnalysisResult {
  final String? resultVideoUrl;
  final int carsDetected;
  final int pedestriansDetected;
  final int warningsCount;
  final int laneDepartures;
  final int safetyScore;
  final List<AnalysisEventData> events;

  const AnalysisResult({
    this.resultVideoUrl,
    this.carsDetected        = 0,
    this.pedestriansDetected = 0,
    this.warningsCount       = 0,
    this.laneDepartures      = 0,
    this.safetyScore         = 0,
    this.events              = const [],
  });
}
