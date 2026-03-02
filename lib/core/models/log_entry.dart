import 'package:flutter/material.dart';

enum LogLevel { debug, info, warning, error, critical }

class LogEntry {
  final String   id;
  final LogLevel level;
  final String   message;
  final String?  source;
  final DateTime createdAt;

  const LogEntry({
    required this.id, required this.level,
    required this.message, this.source, required this.createdAt,
  });

  factory LogEntry.fromJson(Map<String, dynamic> j) {
    final lvl = _parseLevel(j['level'] as String? ?? 'INFO');
    final ts  = j['created_at'] as String? ?? DateTime.now().toIso8601String();
    return LogEntry(
      id:        j['id']?.toString() ?? '',
      level:     lvl,
      message:   j['message'] as String? ?? '',
      source:    j['source']  as String?,
      createdAt: DateTime.tryParse(ts) ?? DateTime.now(),
    );
  }

  static LogLevel _parseLevel(String raw) {
    switch (raw.toUpperCase()) {
      case 'DEBUG':    return LogLevel.debug;
      case 'INFO':     return LogLevel.info;
      case 'WARNING':  return LogLevel.warning;
      case 'ERROR':    return LogLevel.error;
      case 'CRITICAL': return LogLevel.critical;
      default:         return LogLevel.info;
    }
  }

  String get levelLabel => level.name.toUpperCase();

  Color get levelColor {
    switch (level) {
      case LogLevel.debug:    return const Color(0xFF7F7F7F);
      case LogLevel.info:     return const Color(0xFF33CC72);
      case LogLevel.warning:  return const Color(0xFFFFCC33);
      case LogLevel.error:    return const Color(0xFFFF4D4D);
      case LogLevel.critical: return const Color(0xFFCC0000);
    }
  }

  String get formattedTime {
    final h  = createdAt.hour.toString().padLeft(2, '0');
    final m  = createdAt.minute.toString().padLeft(2, '0');
    final s  = createdAt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String toExportLine() => '$formattedTime - $levelLabel - $message';
}
