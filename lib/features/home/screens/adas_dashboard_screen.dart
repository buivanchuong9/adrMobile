import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import '../../../core/widgets/highcharts_3d_widget.dart';
import '../../../main.dart' show iosSlide;
import '../../profile/screens/profile_screen.dart';
import '../../settings/screens/settings_screen.dart';

const _bg     = Color(0xFFF5F5F5);
const _card   = Color(0xFFFFFFFF);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);

class AdasDashboardScreen extends StatelessWidget {
  const AdasDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── App Bar ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _ink, borderRadius: BorderRadius.circular(11),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: const Icon(Icons.directions_car_filled_rounded,
                          color: _accent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('HỆ THỐNG ADAS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                            color: _ink, letterSpacing: 0.4))),

                    // Online pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _card, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 7, height: 7, decoration: const BoxDecoration(
                            color: Color(0xFF22C55E), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('CHỜ', style: TextStyle(fontSize: 11,
                            fontWeight: FontWeight.w700, color: _ink)),
                      ]),
                    ),
                    const SizedBox(width: 8),

                    // Avatar → Profile
                    GestureDetector(
                      onTap: () => Navigator.push(context, iosSlide(const ProfileScreen())),
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: _card, borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(Icons.person_outline_rounded, size: 19, color: _sub),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Settings
                    GestureDetector(
                      onTap: () => Navigator.push(context, iosSlide(const SettingsScreen())),
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: _card, borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(Icons.settings_outlined, size: 18, color: _sub),
                      ),
                    ),
                  ]),
                ),
              ),

              // ── Page heading ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Bảng Điều Khiển',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800,
                            color: _ink, letterSpacing: -0.5, height: 1.1)),
                    const SizedBox(height: 4),
                    Text('Hệ thống đang chờ phân tích',
                        style: TextStyle(fontSize: 14, color: _sub)),
                  ]),
                ),
              ),

              // ── Hero dark card ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                    decoration: BoxDecoration(
                      color: _ink,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 28, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('Hiệu Suất Hệ Thống',
                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.50),
                                fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: _accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _accent.withValues(alpha: 0.30)),
                          ),
                          child: const Text('v3.0 PRO',
                              style: TextStyle(fontSize: 11, color: _accent,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: const Text('Thị Giác AI Thời Gian Thực',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                                color: Colors.white, height: 1.2)),
                      ),
                      const SizedBox(height: 22),
                      Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _HeroStat(icon: Icons.verified_rounded, value: '--', label: 'Điểm An Toàn'),
                            _HeroStat(icon: Icons.directions_car_outlined, value: '0', label: 'Xe Đã Gặp'),
                            _HeroStat(icon: Icons.warning_amber_rounded, value: '0', label: 'Lệch Làn'),
                          ]),
                    ]),
                  ),
                ),
              ),

              // ── Section title ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: Row(children: [
                    const Text('Chỉ Số Lái Xe',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _ink)),
                    const Spacer(),
                    Text('Phiên này', style: TextStyle(fontSize: 13, color: _sub)),
                  ]),
                ),
              ),

              // ── Cards grid ────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 12,
                    mainAxisSpacing: 12, childAspectRatio: 0.88,
                  ),
                  delegate: SliverChildListDelegate([
                    _StatCard(icon: Icons.shield_rounded, color: const Color(0xFFEF4444), label: 'An Toàn'),
                    _StatCard(icon: Icons.directions_car_rounded, color: _accent, label: 'Xe gặp'),
                    _StatCard(icon: Icons.swap_horiz_rounded, color: const Color(0xFF22C55E), label: 'Lệch làn'),
                  ]),
                ),
              ),

              // ── Highcharts 3D analytics chart ─────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 48),
                  child: _DashboardChartCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Dashboard Chart Card ─────────────────────────────────────────────────────
class _DashboardChartCard extends StatelessWidget {
  const _DashboardChartCard();

  static const _safetyData = <Map<String, dynamic>>[
    {'label': 'T2', 'y': 72}, {'label': 'T3', 'y': 68}, {'label': 'T4', 'y': 81},
    {'label': 'T5', 'y': 75}, {'label': 'T6', 'y': 89}, {'label': 'T7', 'y': 84},
    {'label': 'CN', 'y': 91},
  ];
  static const _driverData = <Map<String, dynamic>>[
    {'label': 'T2', 'y': 65}, {'label': 'T3', 'y': 70}, {'label': 'T4', 'y': 77},
    {'label': 'T5', 'y': 73}, {'label': 'T6', 'y': 85}, {'label': 'T7', 'y': 79},
    {'label': 'CN', 'y': 88},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(11),
                boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.35),
                    blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.analytics_rounded, size: 19, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Phân Tích Hành Trình',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _ink)),
              Text('Điểm an toàn 7 ngày gần nhất',
                  style: TextStyle(fontSize: 12, color: _sub)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.35)),
              ),
              child: const Text('7 ngày', style: TextStyle(
                  fontSize: 10, color: Color(0xFF16A34A), fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
        // legend
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Row(children: [
            _Legend(color: _accent, label: 'Dashcam'),
            const SizedBox(width: 16),
            const _Legend(color: Color(0xFF7C3AED), label: 'Tài xế'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('TB: 80/100',
                  style: TextStyle(fontSize: 10, color: _accent, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
        // Highcharts 3D dual-series chart
        Highcharts3DWidget(
          dataPoints: _safetyData,
          height: 220,
          seriesName: 'Dashcam',
          extraSeriesData: _driverData,
          extraSeriesName: 'Tài xế',
          extraSeriesColor: '#7C3AED',
        ),
        // metric pills
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
            _MetricPill(label: 'An toàn nhất', value: '91', color: Color(0xFF22C55E)),
            _MetricPill(label: 'Thấp nhất',    value: '68', color: Color(0xFFEF4444)),
            _MetricPill(label: 'Trung bình',   value: '80', color: _accent),
          ]),
        ),
      ]),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 10, height: 3,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 5),
    Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
  ]);
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.18)),
    ),
    child: Column(children: [
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: const TextStyle(fontSize: 9, color: _sub, fontWeight: FontWeight.w500)),
    ]),
  );
}

// ─── Hero stat ────────────────────────────────────────────────────────────────
class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(icon, color: Colors.white.withValues(alpha: 0.50), size: 22),
    const SizedBox(height: 6),
    Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
    const SizedBox(height: 3),
    Text(label, textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.50),
            fontWeight: FontWeight.w500)),
  ]);
}

// ─── Stat card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.color, required this.label});
  final IconData icon;
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
    decoration: BoxDecoration(
      color: _card, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _border),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12, offset: const Offset(0, 4))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      const Spacer(),
      const Text('--', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _ink)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: _sub, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(value: 0, color: color,
            backgroundColor: color.withValues(alpha: 0.08), minHeight: 3)),
    ]),
  );
}

@Preview(name: 'Dashboard')
Widget previewAdasDashboard() =>
    const MaterialApp(debugShowCheckedModeBanner: false, home: AdasDashboardScreen());
