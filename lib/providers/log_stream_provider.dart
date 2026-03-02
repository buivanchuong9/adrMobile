import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/log_entry.dart';
import '../core/constants/constants.dart';

enum LogConnectionState { disconnected, connecting, connected, error }

class LogStreamProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<LogEntry>       _logs        = [];
  LogLevel?            _filter;           // null = ALL
  LogConnectionState   _connState   = LogConnectionState.disconnected;
  String?              _connError;
  RealtimeChannel?     _channel;

  List<LogEntry>       get logs         => _filteredLogs();
  LogLevel?            get filter        => _filter;
  LogConnectionState   get connState     => _connState;
  String?              get connError     => _connError;
  int                  get totalCount    => _logs.length;

  List<LogEntry> _filteredLogs() => _filter == null
      ? List.unmodifiable(_logs)
      : List.unmodifiable(_logs.where((l) => l.level == _filter));

  void setFilter(LogLevel? level) {
    _filter = level;
    notifyListeners();
  }

  // ── Connect to Supabase Realtime ──────────────────────────────────────────
  Future<void> connect() async {
    _connState = LogConnectionState.connecting;
    _connError = null;
    notifyListeners();

    // Fetch history (50 most recent)
    try {
      final history = await _supabase
          .from('logs')
          .select()
          .order('created_at', ascending: false)
          .limit(50);
      _logs = history
          .map((j) => LogEntry.fromJson(j as Map<String, dynamic>))
          .toList();

      // newest first already
    } catch (e) {
      _connError = e.toString();
    }
    notifyListeners();

    // Subscribe to realtime inserts
    _channel = _supabase.channel('public:logs');
    _channel!
        .onPostgresChanges(
          event:    PostgresChangeEvent.insert,
          schema:   'public',
          table:    'logs',
          callback: (payload) {
            final entry = LogEntry.fromJson(
                payload.newRecord as Map<String, dynamic>);
            _logs.insert(0, entry); // newest first
            if (_logs.length > AppConstants.maxLogEntries) {
              _logs = _logs.sublist(0, AppConstants.maxLogEntries);
            }
            notifyListeners();
          },
        )
        .subscribe((status, [error]) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            _connState = LogConnectionState.connected;
          } else if (error != null) {
            _connState = LogConnectionState.error;
            _connError = error.toString();
          }
          notifyListeners();
        });
  }

  void disconnect() {
    _channel?.unsubscribe();
    _channel    = null;
    _connState  = LogConnectionState.disconnected;
    notifyListeners();
  }

  String exportAll() => _logs
      .map((l) => l.toExportLine())
      .join('\n');

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
