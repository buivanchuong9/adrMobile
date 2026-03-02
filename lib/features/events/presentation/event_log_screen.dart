import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:animate_do/animate_do.dart' as animate_do;

// Design tokens
const _kBlue   = Color(0xFF2563EB);
const _kGreen  = Color(0xFF10B981);
const _kAmber  = Color(0xFFF59E0B);
const _kRed    = Color(0xFFEF4444);
const _kPurple = Color(0xFF8B5CF6);
const _kBg     = Color(0xFFF1F5F9);
const _kSurf   = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE2E8F0);
const _kInk    = Color(0xFF0F172A);
const _kMuted  = Color(0xFF64748B);

class EventLogScreen extends StatefulWidget {
  const EventLogScreen({super.key});

  @override
  State<EventLogScreen> createState() => _EventLogScreenState();
}

class _EventLogScreenState extends State<EventLogScreen> {
  bool _isDragging = false;

  final List<_VideoFile> _files = [
    _VideoFile('Route_A_morning.mp4',   '128 MB', '00:14:32', _kGreen,  _Status.done),
    _VideoFile('Evening_route_03.mp4',  '94 MB',  '00:10:18', _kAmber,  _Status.processing),
    _VideoFile('Highway_cam_02.mp4',    '212 MB', '00:24:07', _kBlue,   _Status.done),
    _VideoFile('Incident_log_07.mp4',   '41 MB',  '00:04:55', _kRed,    _Status.failed),
    _VideoFile('Parking_lot_night.mp4', '76 MB',  '00:08:22', _kPurple, _Status.done),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      animate_do.FadeInUp(
                        duration: const Duration(milliseconds: 450),
                        child: _buildUploadZone(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Recent Uploads',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                            letterSpacing: 0.5, color: _kMuted),
                      ),
                      const SizedBox(height: 12),
                      ..._files.asMap().entries.map((e) {
                        return animate_do.FadeInUp(
                          delay: Duration(milliseconds: e.key * 60),
                          duration: const Duration(milliseconds: 400),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _VideoTile(file: e.value),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return animate_do.FadeInDown(
      duration: const Duration(milliseconds: 450),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kSurf,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _kBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _kInk),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Video Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _kInk)),
                  Text('Upload & monitor footage', style: TextStyle(fontSize: 12, color: _kMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _kBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kBlue.withOpacity(0.2)),
              ),
              child: const Text('${5} files',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _kBlue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadZone() {
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); /* file picker logic */ },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: _isDragging ? _kBlue.withOpacity(0.06) : _kSurf,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isDragging ? _kBlue : _kBorder,
            width: _isDragging ? 2 : 1,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: _kBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.cloud_upload_rounded, size: 30, color: _kBlue),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tap to upload video',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _kInk),
            ),
            const SizedBox(height: 4),
            const Text(
              'MP4, MOV, AVI · Max 2 GB per file',
              style: TextStyle(fontSize: 12, color: _kMuted),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: _kBlue.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: const Text(
                'Browse Files',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Status { done, processing, failed }

class _VideoFile {
  const _VideoFile(this.name, this.size, this.duration, this.color, this.status);
  final String name;
  final String size;
  final String duration;
  final Color color;
  final _Status status;
}

class _VideoTile extends StatelessWidget {
  const _VideoTile({required this.file});
  final _VideoFile file;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (file.status) {
      _Status.done       => ('Completed',  _kGreen.withOpacity(0.10),  _kGreen),
      _Status.processing => ('Processing', _kAmber.withOpacity(0.10),  _kAmber),
      _Status.failed     => ('Failed',     _kRed.withOpacity(0.10),    _kRed),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kSurf,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: file.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.play_circle_fill_rounded, color: file.color, size: 26),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kInk),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('${file.size}  ·  ${file.duration}',
                    style: const TextStyle(fontSize: 11, color: _kMuted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (file.status == _Status.processing)
                  SizedBox(
                    width: 8, height: 8,
                    child: CircularProgressIndicator(strokeWidth: 1.5, color: _kAmber),
                  )
                else
                  Icon(
                    file.status == _Status.done ? Icons.check_circle_rounded : Icons.error_rounded,
                    size: 10, color: fg,
                  ),
                const SizedBox(width: 4),
                Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget Previews
// ---------------------------------------------------------------------------

@Preview(name: 'EventLogScreen')
Widget previewEventLogScreen() => MaterialApp(home: const EventLogScreen());