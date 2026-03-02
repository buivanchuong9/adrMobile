import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:animate_do/animate_do.dart' as animate_do;

// Design tokens
const _kBlue   = Color(0xFF2563EB);
const _kGreen  = Color(0xFF10B981);
const _kAmber  = Color(0xFFF59E0B);
const _kPurple = Color(0xFF8B5CF6);
const _kTeal   = Color(0xFF14B8A6);
const _kBg     = Color(0xFFF1F5F9);
const _kSurf   = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE2E8F0);
const _kInk    = Color(0xFF0F172A);
const _kMuted  = Color(0xFF64748B);

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final _searchCtrl = TextEditingController();
  int _filterIndex = 0;
  String _query = '';

  static const _filters = ['All', 'Completed', 'Processing', 'Flagged'];

  final _videos = const [
    _Video('Route A — Morning',   '14:32', '128 MB', '2h ago',  _kGreen,  false),
    _Video('Evening Route 03',    '10:18', '94 MB',  '3h ago',  _kAmber,  true),
    _Video('Highway Camera 02',   '24:07', '212 MB', 'Yesterday', _kBlue, false),
    _Video('Incident Log #07',    '04:55', '41 MB',  'Yesterday', _kPurple, true),
    _Video('Parking Lot Night',   '08:22', '76 MB',  '2 days',  _kTeal,   false),
    _Video('Downtown Patrol',     '18:44', '165 MB', '2 days',  _kGreen,  false),
    _Video('Bridge Crossing 01',  '06:11', '52 MB',  '3 days',  _kAmber,  false),
    _Video('School Zone Monitor', '12:30', '110 MB', '4 days',  _kBlue,   true),
  ];

  List<_Video> get _filtered {
    final q = _query.toLowerCase();
    return _videos.where((v) {
      final matchQ = q.isEmpty || v.name.toLowerCase().contains(q);
      return matchQ;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildFilters(),
                  ],
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? _buildEmpty()
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: list.length,
                        itemBuilder: (_, i) => animate_do.FadeInUp(
                          delay: Duration(milliseconds: i * 50),
                          duration: const Duration(milliseconds: 380),
                          child: _VideoCard(video: list[i]),
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Video Library', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _kInk)),
                  Text('Browse all recorded footage', style: TextStyle(fontSize: 12, color: _kMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _kGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kGreen.withOpacity(0.2)),
              ),
              child: const Text('48 clips',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _kGreen)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _kSurf,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 13, color: _kInk),
        decoration: const InputDecoration(
          hintText: 'Search videos...',
          hintStyle: TextStyle(fontSize: 13, color: _kMuted),
          prefixIcon: Icon(Icons.search_rounded, size: 18, color: _kMuted),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final sel = _filterIndex == i;
          return GestureDetector(
            onTap: () { HapticFeedback.lightImpact(); setState(() => _filterIndex = i); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? _kBlue : _kSurf,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: sel ? _kBlue : _kBorder),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: sel ? Colors.white : _kMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_rounded, size: 56, color: _kBorder),
          const SizedBox(height: 12),
          const Text('No videos found', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _kMuted)),
        ],
      ),
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────
class _Video {
  const _Video(this.name, this.duration, this.size, this.date, this.color, this.flagged);
  final String name;
  final String duration;
  final String size;
  final String date;
  final Color color;
  final bool flagged;
}

// ─── Video card ───────────────────────────────────────────────────────────────
class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});
  final _Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurf,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: video.color.withOpacity(0.10),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                ),
                child: Center(
                  child: Icon(Icons.play_circle_fill_rounded, size: 38, color: video.color),
                ),
              ),
              // Duration badge
              Positioned(
                bottom: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(video.duration,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              // Flag badge
              if (video.flagged)
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.flag_rounded, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kInk),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.storage_rounded, size: 10, color: _kMuted),
                    const SizedBox(width: 3),
                    Text(video.size, style: const TextStyle(fontSize: 10, color: _kMuted)),
                    const Spacer(),
                    Text(video.date, style: const TextStyle(fontSize: 10, color: _kMuted)),
                  ],
                ),
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

@Preview(name: 'VehicleListScreen')
Widget previewVehicleListScreen() => MaterialApp(home: const VehicleListScreen());