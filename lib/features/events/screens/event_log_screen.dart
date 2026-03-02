import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/log_stream_provider.dart';
import '../../../core/models/log_entry.dart';

const _bg     = Color(0xFFFFFFFF);
const _canvas = Color(0xFFF5F5F5);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);

class EventLogScreen extends StatefulWidget {
  const EventLogScreen({super.key});
  @override
  State<EventLogScreen> createState() => _EventLogScreenState();
}

class _EventLogScreenState extends State<EventLogScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogStreamProvider>().connect();
    });
  }

  @override
  void dispose() { _scroll.dispose(); super.dispose(); }

  void _scrollToTop() {
    if (_scroll.hasClients) {
      _scroll.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogStreamProvider>(
      builder: (_, prov, __) {
        // Auto-scroll to top when new log arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (prov.logs.isNotEmpty) _scrollToTop();
        });

        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            bottom: false,
            child: Column(children: [
              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(children: [
                  const Text('Live Logs', style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800, color: _ink)),
                  const Spacer(),
                  _ConnBadge(state: prov.connState),
                  const SizedBox(width: 8),
                  // Export
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      // Could share via share_plus if desired
                    },
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(color: _canvas,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _border)),
                      child: const Icon(Icons.download_outlined, size: 18, color: _ink)),
                  ),
                ]),
              ),

              // ── Filter tabs ───────────────────────────────────────────────
              _FilterBar(
                current: prov.filter,
                onSelect: (lvl) => prov.setFilter(lvl),
              ),

              // ── Log list ─────────────────────────────────────────────────
              Expanded(
                child: prov.logs.isEmpty
                    ? _EmptyState(state: prov.connState, error: prov.connError)
                    : ListView.separated(
                        controller: _scroll,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                        itemCount: prov.logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (_, i) {
                          final log = prov.logs[i];
                          return _LogRow(entry: log);
                        },
                      ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

// ─── Connection badge ─────────────────────────────────────────────────────────
class _ConnBadge extends StatelessWidget {
  const _ConnBadge({required this.state});
  final LogConnectionState state;
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state) {
      LogConnectionState.connected    => ('● Đã kết nối',   const Color(0xFF22C55E)),
      LogConnectionState.connecting   => ('◌ Đang kết nối', const Color(0xFFFAC71F)),
      LogConnectionState.disconnected => ('○ Ngoại tuyến',  _sub),
      LogConnectionState.error        => ('✕ Lỗi',          const Color(0xFFEF4444)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25))),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

// ─── Filter bar ───────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.current, required this.onSelect});
  final LogLevel? current;
  final void Function(LogLevel?) onSelect;

  @override
  Widget build(BuildContext context) {
    final items = <(String, LogLevel?)>[
      ('Tất cả', null),
      ('DEBUG',    LogLevel.debug),
      ('INFO',     LogLevel.info),
      ('WARNING',  LogLevel.warning),
      ('ERROR',    LogLevel.error),
      ('CRITICAL', LogLevel.critical),
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (label, lvl) = items[i];
          final active = current == lvl;
          final color  = lvl != null ? _levelColor(lvl) : const Color(0xFF111111);
          return GestureDetector(
            onTap: () => onSelect(lvl),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: active ? color.withValues(alpha: 0.12) : _canvas,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active ? color.withValues(alpha: 0.35) : _border)),
              child: Center(child: Text(label, style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: active ? color : _sub))),
            ),
          );
        },
      ),
    );
  }

  Color _levelColor(LogLevel l) => switch (l) {
    LogLevel.debug    => const Color(0xFF7F7F7F),
    LogLevel.info     => const Color(0xFF33CC72),
    LogLevel.warning  => const Color(0xFFFFCC33),
    LogLevel.error    => const Color(0xFFFF4D4D),
    LogLevel.critical => const Color(0xFFCC0000),
  };
}

// ─── Log row ──────────────────────────────────────────────────────────────────
class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry});
  final LogEntry entry;
  @override
  Widget build(BuildContext context) {
    final c = entry.levelColor;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: _canvas, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 8, height: 8,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6)),
                child: Text(entry.levelLabel, style: TextStyle(fontSize: 10,
                    fontWeight: FontWeight.w700, color: c))),
              const SizedBox(width: 8),
              Text(entry.formattedTime,
                  style: const TextStyle(fontSize: 11, color: _sub)),
              if (entry.source != null) ...[
                const SizedBox(width: 6),
                Expanded(child: Text(entry.source!,
                    style: const TextStyle(fontSize: 10, color: _sub),
                    overflow: TextOverflow.ellipsis)),
              ],
            ]),
            const SizedBox(height: 5),
            Text(entry.message, style: const TextStyle(
                fontSize: 13, color: _ink, height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.state, this.error});
  final LogConnectionState state;
  final String? error;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(state == LogConnectionState.connecting
          ? Icons.sync_rounded : Icons.receipt_long_outlined,
          size: 48, color: _sub),
      const SizedBox(height: 12),
      Text(state == LogConnectionState.connecting
          ? 'Đang kết nối...' : 'Chưa có logs',
          style: const TextStyle(fontSize: 15, color: _sub)),
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 32, right: 32),
          child: Text(error!, style: const TextStyle(fontSize: 12,
              color: Color(0xFFEF4444)), textAlign: TextAlign.center)),
    ]),
  );
}
