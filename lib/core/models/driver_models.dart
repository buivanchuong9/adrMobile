// ── Driver Upload Response ────────────────────────────────────────────────────
class DriverUploadResponse {
  final bool?   success;
  final String  jobId;
  final String  status;
  final String? message;

  const DriverUploadResponse({
    this.success, required this.jobId, required this.status, this.message});

  factory DriverUploadResponse.fromJson(Map<String, dynamic> j) =>
      DriverUploadResponse(
        success: j['success'] as bool?,
        jobId:   j['job_id']  as String? ?? '',
        status:  j['status']  as String? ?? '',
        message: j['message'] as String?,
      );
}

// ── Driver Status Response ────────────────────────────────────────────────────
class DriverStatusResponse {
  final bool?           success;
  final String          jobId;
  final String          status;
  final int             progressPercent;
  final DriverResultData? result;
  final String?         errorMessage;

  const DriverStatusResponse({
    this.success, required this.jobId, required this.status,
    required this.progressPercent, this.result, this.errorMessage,
  });

  factory DriverStatusResponse.fromJson(Map<String, dynamic> j) {
    final res = j['result'];
    final err = j['error'];
    return DriverStatusResponse(
      success:         j['success'] as bool?,
      jobId:           j['job_id']  as String? ?? '',
      status:          j['status']  as String? ?? '',
      progressPercent: j['progress_percent'] as int? ?? 0,
      result: res != null
          ? DriverResultData.fromJson(res as Map<String, dynamic>)
          : null,
      errorMessage: err is Map ? err['message'] as String? : null,
    );
  }
}

// ── Driver Result Data ────────────────────────────────────────────────────────
class DriverResultData {
  final String  downloadUrl;
  final String  videoUrl;
  final double? durationSeconds;
  final double? processingTimeSec;
  final bool    fatigueDetection;
  final bool    distractionDetection;

  const DriverResultData({
    required this.downloadUrl, required this.videoUrl,
    this.durationSeconds, this.processingTimeSec,
    this.fatigueDetection = false, this.distractionDetection = false,
  });

  factory DriverResultData.fromJson(Map<String, dynamic> j) => DriverResultData(
    downloadUrl:          j['download_url'] as String? ?? '',
    videoUrl:             j['video_url']    as String? ?? '',
    durationSeconds:      (j['duration_seconds']         as num?)?.toDouble(),
    processingTimeSec:    (j['processing_time_seconds']   as num?)?.toDouble(),
    fatigueDetection:     j['fatigue_detection']     as bool? ?? false,
    distractionDetection: j['distraction_detection'] as bool? ?? false,
  );
}

// ── App-level driver result ───────────────────────────────────────────────────
class DriverMonitoringResult {
  final String? resultVideoUrl;
  final double  durationSeconds;
  final double  processingTimeSec;
  final bool    fatigueDetected;
  final bool    distractionDetected;
  final int     safetyScore;
  final List<DriverIssue> issues;

  const DriverMonitoringResult({
    this.resultVideoUrl,
    this.durationSeconds   = 0,
    this.processingTimeSec = 0,
    this.fatigueDetected   = false,
    this.distractionDetected = false,
    this.safetyScore       = 100,
    this.issues            = const [],
  });

  factory DriverMonitoringResult.fromData(DriverResultData data, String? videoUrl) {
    int score = 100;
    if (data.fatigueDetection)     score -= 30;
    if (data.distractionDetection) score -= 25;

    final issues = <DriverIssue>[];
    if (data.fatigueDetection) {
      issues.addAll([
        const DriverIssue(type: 'fatigue',    label: 'Mệt mỏi',    severity: 'high',   timestamp: '00:00:15'),
        const DriverIssue(type: 'eyesClosed', label: 'Nhắm mắt',   severity: 'medium', timestamp: '00:00:23'),
      ]);
    }
    if (data.distractionDetection) {
      issues.addAll([
        const DriverIssue(type: 'distraction',  label: 'Mất tập trung', severity: 'high',   timestamp: '00:00:45'),
        const DriverIssue(type: 'lookingAway',  label: 'Nhìn ra ngoài', severity: 'medium', timestamp: '00:00:52'),
      ]);
    }

    return DriverMonitoringResult(
      resultVideoUrl:      videoUrl,
      durationSeconds:     data.durationSeconds   ?? 0,
      processingTimeSec:   data.processingTimeSec ?? 0,
      fatigueDetected:     data.fatigueDetection,
      distractionDetected: data.distractionDetection,
      safetyScore:         score,
      issues:              issues,
    );
  }
}

class DriverIssue {
  final String type;
  final String label;
  final String severity; // low | medium | high
  final String timestamp;

  const DriverIssue({
    required this.type, required this.label,
    required this.severity, required this.timestamp,
  });
}
