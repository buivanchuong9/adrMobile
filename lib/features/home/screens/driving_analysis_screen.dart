import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../providers/driving_analysis_provider.dart';
import '../../../core/models/analysis_models.dart';

const _bg     = Color(0xFFFFFFFF);
const _canvas = Color(0xFFF5F5F5);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);

class DrivingAnalysisScreen extends StatefulWidget {
  const DrivingAnalysisScreen({super.key});
  @override
  State<DrivingAnalysisScreen> createState() => _DrivingAnalysisScreenState();
}

class _DrivingAnalysisScreenState extends State<DrivingAnalysisScreen> {
  final _picker = ImagePicker();
  File? _selectedFile;
  VideoPlayerController? _videoCtrl;

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final media = await _picker.pickVideo(source: ImageSource.gallery);
    if (media == null) return;
    setState(() { _selectedFile = File(media.path); });
  }

  Future<void> _startAnalysis() async {
    if (_selectedFile == null) return;
    HapticFeedback.mediumImpact();
    final analysisProvider = context.read<DrivingAnalysisProvider>();
    await analysisProvider.analyzeVideo(_selectedFile!);
    // Show result video
    final res = analysisProvider.result;
    if (res?.resultVideoUrl != null && mounted) {
      _videoCtrl = VideoPlayerController.networkUrl(
          Uri.parse(res!.resultVideoUrl!));
      await _videoCtrl!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrivingAnalysisProvider>(
      builder: (ctx, prov, _) {
        if (prov.state == AnalysisState.completed && prov.result != null) {
          return _ResultView(result: prov.result!, videoCtrl: _videoCtrl,
              onReset: () {
                prov.reset();
                setState(() { _selectedFile = null; _videoCtrl?.dispose(); _videoCtrl = null; });
              });
        }
        return _UploadView(
          selectedFile: _selectedFile,
          state: prov.state,
          progress: prov.progress,
          statusMsg: prov.statusMsg,
          errorMsg: prov.errorMsg,
          onPick: _pick,
          onAnalyze: _startAnalysis,
        );
      },
    );
  }
}

// ─── Upload view ──────────────────────────────────────────────────────────────
class _UploadView extends StatelessWidget {
  const _UploadView({
    required this.selectedFile, required this.state, required this.progress,
    required this.statusMsg, this.errorMsg,
    required this.onPick, required this.onAnalyze,
  });
  final File? selectedFile;
  final AnalysisState state;
  final double progress;
  final String statusMsg;
  final String? errorMsg;
  final VoidCallback onPick;
  final VoidCallback onAnalyze;

  @override
  Widget build(BuildContext context) {
    final isBusy = state == AnalysisState.uploading || state == AnalysisState.processing;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8, offset: const Offset(0, 3))]),
                child: const Icon(Icons.directions_car_filled_rounded, color: _accent, size: 22)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Phân Tích Lái Xe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _ink)),
                Text('AI-Powered Video Analysis', style: TextStyle(fontSize: 12, color: _sub)),
              ]),
            ]),
            const SizedBox(height: 26),

            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: const Text('Upload Video Dashcam', style: TextStyle(fontSize: 28,
                  fontWeight: FontWeight.w800, color: _ink, height: 1.15, letterSpacing: -0.4)),
            ),
            const SizedBox(height: 10),
            const Text('Upload video dashcam để AI phân tích hành vi lái xe, phát hiện làn đường và đánh giá an toàn.',
                style: TextStyle(fontSize: 14, color: _sub, height: 1.55)),
            const SizedBox(height: 20),

            // ── Progress bar shown during analysis ───────────────────────────
            if (isBusy) ...[
              ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress > 0 ? progress : null,
                  color: _accent,
                  backgroundColor: _accent.withValues(alpha: 0.12),
                  minHeight: 4,
                )),
              const SizedBox(height: 8),
              Text(statusMsg, style: const TextStyle(fontSize: 13, color: _sub)),
              const SizedBox(height: 12),
            ],

            // ── Error message ────────────────────────────────────────────────
            if (state == AnalysisState.failed && errorMsg != null) ...[
              Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.25))),
                child: Text(errorMsg!, style: const TextStyle(fontSize: 13,
                    color: Color(0xFFEF4444))),
              ),
              const SizedBox(height: 12),
            ],

            // ── Upload tap zone ──────────────────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: isBusy ? null : onPick,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _canvas, borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: _border),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16, offset: const Offset(0, 4))]),
                  child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 72, height: 72,
                      decoration: BoxDecoration(color: _bg, shape: BoxShape.circle,
                          border: Border.all(color: _border, width: 1.5),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12, offset: const Offset(0, 4))]),
                      child: Icon(selectedFile != null ? Icons.check_rounded : Icons.upload_rounded,
                          color: selectedFile != null ? const Color(0xFF22C55E) : _accent, size: 32)),
                    const SizedBox(height: 18),
                    Text(selectedFile != null ? selectedFile!.path.split('/').last : 'Chọn Video',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _ink),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text(selectedFile != null ? 'Đã chọn — bấm Phân Tích' : 'Chạm để chọn từ thư viện',
                        style: const TextStyle(fontSize: 13, color: _sub)),
                    const SizedBox(height: 22),
                    Wrap(spacing: 8, children: const [
                      _Chip(icon: Icons.movie_outlined,   label: 'MP4, MOV'),
                      _Chip(icon: Icons.data_usage_outlined, label: '< 500MB'),
                      _Chip(icon: Icons.timer_outlined,   label: '1–3 min'),
                    ]),
                  ])),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Analyze button ───────────────────────────────────────────────
            if (selectedFile != null && !isBusy)
              GestureDetector(
                onTap: onAnalyze,
                child: Container(
                  height: 56, width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _accent, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.35),
                        blurRadius: 20, offset: const Offset(0, 7))]),
                  child: const Center(child: Text('Bắt đầu phân tích',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
              ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}

// ─── Result view ──────────────────────────────────────────────────────────────
class _ResultView extends StatelessWidget {
  const _ResultView({required this.result, this.videoCtrl, required this.onReset});
  final AnalysisResult result;
  final VideoPlayerController? videoCtrl;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final score = result.safetyScore;
    final scoreColor = score >= 80
        ? const Color(0xFF22C55E)
        : score >= 60 ? _accent : const Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // header
              Row(children: [
                const Text('Kết Quả Phân Tích',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _ink)),
                const Spacer(),
                GestureDetector(onTap: onReset,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: _canvas,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border)),
                    child: const Text('Làm mới', style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: _ink)))),
              ]),
              const SizedBox(height: 24),

              // Safety score circle
              Center(child: Column(children: [
                Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 120, height: 120,
                    child: CircularProgressIndicator(
                      value: score / 100.0, strokeWidth: 10,
                      color: scoreColor,
                      backgroundColor: scoreColor.withValues(alpha: 0.12),
                    )),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('$score', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: scoreColor)),
                    const Text('/100', style: TextStyle(fontSize: 13, color: _sub)),
                  ]),
                ]),
                const SizedBox(height: 8),
                const Text('Điểm An Toàn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
              ])),
              const SizedBox(height: 24),

              // Metrics row
              Row(children: [
                _MetricBox(label: 'Xe',         value: '${result.carsDetected}',        color: _accent),
                const SizedBox(width: 10),
                _MetricBox(label: 'Người đi bộ', value: '${result.pedestriansDetected}', color: const Color(0xFF407AFA)),
                const SizedBox(width: 10),
                _MetricBox(label: 'Lệch làn',   value: '${result.laneDepartures}',      color: const Color(0xFFEF4444)),
                const SizedBox(width: 10),
                _MetricBox(label: 'Cảnh báo',   value: '${result.warningsCount}',       color: const Color(0xFFFAC71F)),
              ]),
              const SizedBox(height: 24),

              // Events
              if (result.events.isNotEmpty) ...[
                const Text('Sự kiện phát hiện',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
                const SizedBox(height: 12),
                ...result.events.map((e) => _EventRow(event: e)),
              ],

              // Video player
              if (videoCtrl != null && videoCtrl!.value.isInitialized) ...[
                const SizedBox(height: 24),
                const Text('Video kết quả',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: videoCtrl!.value.aspectRatio,
                    child: Stack(children: [
                      VideoPlayer(videoCtrl!),
                      Positioned.fill(child: GestureDetector(
                        onTap: () {
                          videoCtrl!.value.isPlaying
                              ? videoCtrl!.pause()
                              : videoCtrl!.play();
                        },
                        child: videoCtrl!.value.isPlaying
                            ? const SizedBox.shrink()
                            : Container(color: Colors.black38,
                                child: const Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 60)),
                      )),
                    ]),
                  ),
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _canvas, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: _sub),
            textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});
  final AnalysisEventData event;
  @override
  Widget build(BuildContext context) {
    final color = event.severity == 'high'
        ? const Color(0xFFEF4444)
        : event.severity == 'medium'
            ? _accent : const Color(0xFF22C55E);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _canvas, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border)),
      child: Row(children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(event.type,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _ink))),
        Text(event.timestamp, style: const TextStyle(fontSize: 12, color: _sub)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20)),
          child: Text(event.severity, style: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w700, color: color)),
        ),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: _bg, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _border)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: _accent),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w600, color: _accent)),
    ]),
  );
}

@Preview(name: 'Driving Analysis')
Widget previewDrivingAnalysis() =>
    const MaterialApp(debugShowCheckedModeBanner: false, home: DrivingAnalysisScreen());
