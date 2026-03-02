import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:animate_do/animate_do.dart' as animate_do;
import '../../../core/theme/modern_theme_2026.dart';
import '../../analytics/presentation/analytics_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../events/presentation/event_log_screen.dart';
import '../../fleet/presentation/vehicle_list_screen.dart';

// ─── Brand palette ─────────────────────────────────────────────────────────
const _kBlue    = Color(0xFF2563EB);
const _kGreen   = Color(0xFF10B981);
const _kAmber   = Color(0xFFF59E0B);
const _kRed     = Color(0xFFEF4444);
const _kPurple  = Color(0xFF8B5CF6);
const _kBg      = Color(0xFFF1F5F9);
const _kSurface = Color(0xFFFFFFFF);
const _kBorder  = Color(0xFFE2E8F0);
const _kInk     = Color(0xFF0F172A);
const _kMuted   = Color(0xFF64748B);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Column(
            children: [
              _Header(pulseCtrl: _pulseCtrl),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _buildSectionLabel('Overview'),
                      const SizedBox(height: 12),
                      _buildStatsRow(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Quick Actions'),
                      const SizedBox(height: 12),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Recent Activity'),
                      const SizedBox(height: 12),
                      _buildActivityFeed(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: _kMuted,
      ),
    );
  }

  // ─── Stats row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final stats = [
      _StatData('Active',     '12', Icons.videocam_rounded,   _kBlue,   '+2'),
      _StatData('Completed',  '48', Icons.check_circle_rounded, _kGreen, '+5'),
      _StatData('Processing', '3',  Icons.sync_rounded,        _kAmber,  '–'),
      _StatData('Alerts',     '2',  Icons.warning_amber_rounded, _kRed,  '+1'),
    ];

    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Row(
        children: stats.asMap().entries.map((e) {
          final delay = e.key * 60;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: e.key == 0 ? 0 : 10),
              child: animate_do.FadeInUp(
                delay: Duration(milliseconds: delay),
                duration: const Duration(milliseconds: 450),
                child: _StatCard(data: e.value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Quick actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 120),
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              label: 'Upload Video',
              sub: 'Add new footage',
              icon: Icons.cloud_upload_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EventLogScreen())),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _ActionCard(
              label: 'Video Library',
              sub: 'Browse all clips',
              icon: Icons.video_library_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VehicleListScreen())),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Activity feed ─────────────────────────────────────────────────────────
  Widget _buildActivityFeed() {
    final items = [
      _ActivityItem(
        title: 'Video analysis complete',
        sub: 'Route_A_morning.mp4 · 2 min ago',
        icon: Icons.check_circle_rounded,
        color: _kGreen,
      ),
      _ActivityItem(
        title: 'New alert detected',
        sub: 'Harsh braking — Vehicle #04 · 8 min ago',
        icon: Icons.warning_amber_rounded,
        color: _kAmber,
      ),
      _ActivityItem(
        title: 'Upload started',
        sub: 'Evening_route_03.mp4 · 15 min ago',
        icon: Icons.cloud_upload_rounded,
        color: _kBlue,
      ),
      _ActivityItem(
        title: 'Report generated',
        sub: 'Weekly summary — Feb 26 · 1 hr ago',
        icon: Icons.insert_drive_file_rounded,
        color: _kPurple,
      ),
    ];

    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 650),
      delay: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                _ActivityTile(item: e.value),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 60,
                    endIndent: 20,
                    color: _kBorder,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── Bottom nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      (Icons.grid_view_rounded,         Icons.grid_view_rounded,         'Home'),
      (Icons.bar_chart_rounded,          Icons.bar_chart_rounded,          'Analytics'),
      (Icons.play_circle_outline_rounded, Icons.play_circle_fill_rounded, 'Library'),
      (Icons.settings_outlined,          Icons.settings_rounded,          'Settings'),
    ];

    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        height: 70,
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _kBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: items.asMap().entries.map((e) {
            final idx  = e.key;
            final item = e.value;
            final sel  = _navIndex == idx;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _navIndex = idx);
                  switch (idx) {
                    case 1: Navigator.push(context, _route(const AnalyticsScreen()));
                    case 2: Navigator.push(context, _route(const VehicleListScreen()));
                    case 3: Navigator.push(context, _route(const SettingsScreen()));
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: sel ? _kBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        sel ? item.$2 : item.$1,
                        size: 22,
                        color: sel ? Colors.white : _kMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$3,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                          color: sel ? Colors.white : _kMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  PageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Header widget
// ═══════════════════════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  const _Header({required this.pulseCtrl});
  final AnimationController pulseCtrl;

  @override
  Widget build(BuildContext context) {
    return animate_do.FadeInDown(
      duration: const Duration(milliseconds: 550),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _kBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Brand mark
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _kBlue.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Title block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADAS PRO',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: _kInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Video Analytics Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _kMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Live badge
            AnimatedBuilder(
              animation: pulseCtrl,
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _kGreen.withOpacity(0.08 + pulseCtrl.value * 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _kGreen.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _kGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _kGreen.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _kGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Notification bell
            _IconBtn(
              icon: Icons.notifications_none_rounded,
              badge: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Small icon button with optional badge
// ═══════════════════════════════════════════════════════════════════════════════
class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap, this.badge = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder, width: 1),
            ),
            child: Icon(icon, size: 20, color: _kInk),
          ),
          if (badge)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _kRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Stat card
// ═══════════════════════════════════════════════════════════════════════════════
class _StatData {
  const _StatData(this.label, this.value, this.icon, this.color, this.trend);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});
  final _StatData data;

  @override
  Widget build(BuildContext context) {
    final positive = data.trend.startsWith('+');
    final neutral  = data.trend == '–';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          const SizedBox(height: 10),

          // Value
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _kInk,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),

          // Label
          Text(
            data.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _kMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Trend chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (neutral ? _kMuted : positive ? _kGreen : _kRed)
                  .withOpacity(0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              data.trend,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: neutral ? _kMuted : positive ? _kGreen : _kRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Action card
// ═══════════════════════════════════════════════════════════════════════════════
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.sub,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
  final String label;
  final String sub;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.20),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Activity feed
// ═══════════════════════════════════════════════════════════════════════════════
class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.sub,
    required this.icon,
    required this.color,
  });
  final String title;
  final String sub;
  final IconData icon;
  final Color color;
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});
  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(item.icon, color: item.color, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.sub,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _kMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 18, color: _kMuted),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget Previews
// ---------------------------------------------------------------------------

@Preview(name: 'DashboardScreen')
Widget previewDashboardScreen() => MaterialApp(home: const DashboardScreen());