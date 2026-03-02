class VideoJob {
  final String jobId;
  final String? filename;
  final String status; // 'uploading', 'processing', 'completed', 'failed'
  final int progress;
  final DateTime createdAt;
  final String? videoUrl;
  final List<AnalysisEvent>? events;

  VideoJob({
    required this.jobId,
    this.filename,
    required this.status,
    this.progress = 0,
    required this.createdAt,
    this.videoUrl,
    this.events,
  });

  factory VideoJob.fromJson(Map<String, dynamic> json) {
    return VideoJob(
      jobId: json['job_id'] ?? json['id'] ?? '',
      filename: json['filename'],
      status: json['status'] ?? 'processing',
      progress: json['progress'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      videoUrl: json['video_url'] ?? json['url'],
      events: json['events'] != null
          ? (json['events'] as List)
              .map((e) => AnalysisEvent.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'filename': filename,
      'status': status,
      'progress': progress,
      'created_at': createdAt.toIso8601String(),
      'video_url': videoUrl,
      'events': events?.map((e) => e.toJson()).toList(),
    };
  }

  VideoJob copyWith({
    String? jobId,
    String? filename,
    String? status,
    int? progress,
    DateTime? createdAt,
    String? videoUrl,
    List<AnalysisEvent>? events,
  }) {
    return VideoJob(
      jobId: jobId ?? this.jobId,
      filename: filename ?? this.filename,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      videoUrl: videoUrl ?? this.videoUrl,
      events: events ?? this.events,
    );
  }
}

class AnalysisEvent {
  final String type; // 'drowsiness', 'lane_departure', 'distraction', etc.
  final String timestamp;
  final String? vehicleId;
  final String severity; // 'low', 'medium', 'high'
  final Map<String, dynamic>? metadata;

  AnalysisEvent({
    required this.type,
    required this.timestamp,
    this.vehicleId,
    required this.severity,
    this.metadata,
  });

  factory AnalysisEvent.fromJson(Map<String, dynamic> json) {
    return AnalysisEvent(
      type: json['type'] ?? json['event_type'] ?? '',
      timestamp: json['timestamp'] ?? '',
      vehicleId: json['vehicle_id'] ?? json['plate'],
      severity: json['severity'] ?? 'low',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp,
      'vehicle_id': vehicleId,
      'severity': severity,
      'metadata': metadata,
    };
  }

  String get displayName {
    switch (type.toLowerCase()) {
      case 'drowsiness':
      case 'drowsy':
        return 'Drowsiness Detected';
      case 'lane_departure':
      case 'lane':
        return 'Lane Departure';
      case 'distraction':
        return 'Driver Distraction';
      case 'phone_use':
        return 'Phone Usage';
      case 'smoking':
        return 'Smoking Detected';
      case 'no_seatbelt':
        return 'No Seatbelt';
      default:
        return type;
    }
  }
}
