import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../providers/driver_monitoring_provider.dart';
import '../../../core/models/driver_models.dart';

const _bg     = Color(0xFFFFFFFF);
const _canvas = Color(0xFFF5F5F5);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);
const _purple = Color(0xFF7C3AED);

class DriverMonitoringScreen extends StatefulWidget {
  const DriverMonitoringScreen({super.key});
  @override
  State<DriverMonitoringScreen> createState() => _DriverMonitoringScreenState();
}

class _DriverMonitoringScreenState extends State<DriverMonitoringScreen> {
  final _picker = ImagePicker();
  File? _selectedFile;
  VideoPlayerController? _videoCtrl;

  @override
  void dispose() { _videoCtrl?.dispose(); super.dispose(); }

  Future<void> _pick() async {
    final media = await _picker.pickVideo(source: ImageSource.gallery);
    if (media == null) return;
    setState(() => _selectedFile = File(media.path));
  }

  Future<void> _startAnalysis() async {
    if (_selectedFile == null) return;
    HapticFeedback.mediumImpact();
    final driverProvider = context.read<DriverMonitoringProvider>();
    await driverProvider.analyzeVideo(_selectedFile!);
    final res = driverProvider.result;
    if (res?.resultVideoUrl != null && mounted) {
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(res!.resultVideoUrl!));
      await _videoCtrl!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverMonitoringProvider>(
      builder: (ctx, prov, _) {
        if (prov.state == DriverAnalysisState.completed && prov.result != null) {
          return _ResultView(
            result: prov.result!, videoCtrl: _videoCtrl,
            onReset: () {
              prov.reset();
              setState(() {
                _selectedFile = null;
                _videoCtrl?.dispose(); _videoCtrl = null;
              });
            });
        }
        final isBusy = prov.state == DriverAnalysisState.uploading ||
            prov.state == DriverAnalysisState.processing;
        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // ── Badge pill ─────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _purple.withValues(alpha: 0.18))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.remove_red_eye_outlined, size: 14, color: _purple),
                    const SizedBox(width: 6),
                    Text('GIÁM SÁT TÀI XẾ',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                            letterSpacing: 0.8, color: _purple)),
                  ]),
                ),
                const SizedBox(height: 20),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: const Text('Upload Video Giám Sát', style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w800, color: _ink,
                      height: 1.15, letterSpacing: -0.4)),
                ),
                const SizedBox(height: 10),
                const Text('Hệ thống AI phân tích hành vi tài xế, phát hiện buồn ngủ, mất tập trung.',
                    style: TextStyle(fontSize: 14, color: _sub, height: 1.55)),
                const SizedBox(height: 16),

                if (isBusy) ...[
                  ClipRRect(borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: prov.progress > 0 ? prov.progress : null,
                      color: _purple,
                      backgroundColor: _purple.withValues(alpha: 0.12),
                      minHeight: 4,
                    )),
                  const SizedBox(height: 8),
                  Text(prov.statusMsg, style: const TextStyle(fontSize: 13, color: _sub)),
                  const SizedBox(height: 12),
                ],

                if (prov.state == DriverAnalysisState.failed && prov.errorMsg != null) ...[
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.25))),
                    child: Text(prov.errorMsg!, style: const TextStyle(
                        fontSize: 13, color: Color(0xFFEF4444)))),
                  const SizedBox(height: 12),
                ],

                Expanded(
                  child: GestureDetector(
                    onTap: isBusy ? null : _pick,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _canvas, borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: _border),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16, offset: const Offset(0, 4))]),
                      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(width: 80, height: 80, child: Stack(children: [
                          Container(width: 72, height: 72,
                            decoration: BoxDecoration(color: _bg, shape: BoxShape.circle,
                                border: Border.all(color: _border, width: 1.5),
                                boxShadow: [BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 12, offset: const Offset(0, 4))]),
                            child: Icon(
                              _selectedFile != null ? Icons.check_rounded : Icons.person_rounded,
                              size: 36, color: _selectedFile != null ? const Color(0xFF22C55E) : _purple)),
                          Positioned(right: 0, bottom: 0,
                            child: Container(width: 26, height: 26,
                              decoration: BoxDecoration(color: _purple, shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(
                                      color: _purple.withValues(alpha: 0.30),
                                      blurRadius: 8, offset: const Offset(0, 3))]),
                              child: const Icon(Icons.add, color: Colors.white, size: 16))),
                        ])),
                        const SizedBox(height: 18),
                        Text(_selectedFile != null
                            ? _selectedFile!.path.split('/').last : 'Chọn Video Tài Xế',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _ink),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        const Text('MP4, MOV, AVI — tối đa 500MB',
                            style: TextStyle(fontSize: 13, color: _sub)),
                      ])),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (_selectedFile != null && !isBusy)
                  GestureDetector(
                    onTap: _startAnalysis,
                    child: Container(
                      height: 56, width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: _purple, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.35),
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
      },
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.result, this.videoCtrl, required this.onReset});
  final DriverMonitoringResult result;
  final VideoPlayerController? videoCtrl;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final score = result.safetyScore;
    final scoreColor = score >= 80 ? const Color(0xFF22C55E)
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
              Row(children: [
                const Text('Kết Quả Giám Sát', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: _ink)),
                const Spacer(),
                GestureDetector(onTap: onReset,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: _canvas,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border)),
                    child: const Text('Làm mới',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink)))),
              ]),
              const SizedBox(height: 24),

              // Safety score
              Center(child: Column(children: [
                Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 120, height: 120,
                    child: CircularProgressIndicator(
                      value: score / 100.0, strokeWidth: 10,
                      color: scoreColor,
                      backgroundColor: scoreColor.withValues(alpha: 0.12))),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('$score', style: TextStyle(fontSize: 36,
                        fontWeight: FontWeight.w800, color: scoreColor)),
                    const Text('/100', style: TextStyle(fontSize: 13, color: _sub)),
                  ]),
                ]),
                const SizedBox(height: 8),
                const Text('Điểm An Toàn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
              ])),
              const SizedBox(height: 24),

              // Status badges row
              Row(children: [
                _StatusBadge(label: 'Mệt mỏi',
                    detected: result.fatigueDetected),
                const SizedBox(width: 12),
                _StatusBadge(label: 'Mất tập trung',
                    detected: result.distractionDetected),
              ]),
              const SizedBox(height: 24),

              // Issues
              if (result.issues.isNotEmpty) ...[
                const Text('Vấn đề phát hiện',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
                const SizedBox(height: 12),
                ...result.issues.map((i) => _IssueRow(issue: i)),
              ],

              // Video
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
                              ? videoCtrl!.pause() : videoCtrl!.play();
                        },
                        child: videoCtrl!.value.isPlaying
                            ? const SizedBox.shrink()
                            : Container(color: Colors.black38,
                                child: const Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 60)))),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.detected});
  final String label;
  final bool detected;
  @override
  Widget build(BuildContext context) {
    final color = detected ? const Color(0xFFEF4444) : const Color(0xFF22C55E);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.20))),
        child: Column(children: [
          Icon(detected ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
              color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w600, color: _ink)),
          const SizedBox(height: 2),
          Text(detected ? 'Phát hiện' : 'An toàn',
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _IssueRow extends StatelessWidget {
  const _IssueRow({required this.issue});
  final DriverIssue issue;
  @override
  Widget build(BuildContext context) {
    final color = issue.severity == 'high' ? const Color(0xFFEF4444)
        : issue.severity == 'medium' ? _accent : const Color(0xFF22C55E);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _canvas, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border)),
      child: Row(children: [
        Container(width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(issue.label, style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: _ink))),
        Text(issue.timestamp, style: const TextStyle(fontSize: 12, color: _sub)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20)),
          child: Text(issue.severity, style: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w700, color: color))),
      ]),
    );
  }
}

@Preview(name: 'Driver Monitoring')
Widget previewDriverMonitoring() =>
    const MaterialApp(debugShowCheckedModeBanner: false, home: DriverMonitoringScreen());
