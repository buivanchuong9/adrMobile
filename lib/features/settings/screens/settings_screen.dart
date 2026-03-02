import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../main.dart' show iosSlide;
import '../../../providers/theme_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../profile/screens/profile_screen.dart';

const _bg     = Color(0xFFF5F5F5);
const _card   = Color(0xFFFFFFFF);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _speedOffset  = 5.0;
  bool   _fcwEnabled   = true;
  bool   _ldwEnabled   = true;
  bool   _notifEnabled = true;

  Future<void> _signOut() async {
    HapticFeedback.mediumImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Bạn có chắc muốn đăng xuất không?',
            style: TextStyle(color: Color(0xFF666666))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Huỷ', style: TextStyle(color: _sub)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đăng xuất',
                style: TextStyle(color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context, iosSlide(const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final name  = AuthService.fullName ?? 'Người dùng';
    final email = AuthService.email ?? '';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── Header ────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 17, color: _ink),
                      ),
                    ),
                    const Spacer(),
                    const Text('Cài Đặt', style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w700, color: _ink)),
                    const Spacer(),
                    const SizedBox(width: 38),
                  ]),
                ),
              ),

              // ── Profile card ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, iosSlide(const ProfileScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 16, offset: const Offset(0, 4))],
                      ),
                      child: Row(children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _initials(name),
                              style: const TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(name, style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
                          const SizedBox(height: 2),
                          Text(email, style: const TextStyle(
                              fontSize: 13, color: _sub)),
                        ])),
                        Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: _bg, borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(Icons.chevron_right_rounded,
                              size: 18, color: _sub),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),

              // ── ADAS Config ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Cấu Hình ADAS'),
                    const SizedBox(height: 12),
                    _SettingsCard(children: [
                      _ToggleRow(
                        icon: Icons.car_crash_rounded,
                        iconColor: const Color(0xFFEF4444),
                        title: 'Cảnh báo va chạm phía trước',
                        subtitle: 'FCW – Forward Collision Warning',
                        value: _fcwEnabled,
                        onChanged: (v) => setState(() => _fcwEnabled = v),
                      ),
                      const _ItemDiv(),
                      _ToggleRow(
                        icon: Icons.swap_horiz_rounded,
                        iconColor: const Color(0xFF6366F1),
                        title: 'Cảnh báo lệch làn',
                        subtitle: 'LDW – Lane Departure Warning',
                        value: _ldwEnabled,
                        onChanged: (v) => setState(() => _ldwEnabled = v),
                      ),
                      const _ItemDiv(),
                      // Speed offset slider
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                        child: Column(children: [
                          Row(children: [
                            Container(
                              width: 30, height: 30,
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(Icons.speed_rounded,
                                  size: 16, color: _accent),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ngưỡng tốc độ cảnh báo',
                                    style: TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w500, color: _ink)),
                                Text('Speed Limit Alert Offset',
                                    style: TextStyle(fontSize: 11, color: _sub)),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('+${_speedOffset.round()} km/h',
                                  style: const TextStyle(fontSize: 12,
                                      color: _accent, fontWeight: FontWeight.w700)),
                            ),
                          ]),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: _accent,
                              inactiveTrackColor: _accent.withValues(alpha: 0.15),
                              thumbColor: _accent,
                              overlayColor: _accent.withValues(alpha: 0.12),
                              trackHeight: 3,
                            ),
                            child: Slider(
                              value: _speedOffset,
                              min: 0, max: 20, divisions: 4,
                              onChanged: (v) => setState(() => _speedOffset = v),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ]),
                ),
              ),

              // ── App preferences ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Ứng Dụng'),
                    const SizedBox(height: 12),
                    _SettingsCard(children: [
                      _ToggleRow(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        title: 'Chế độ tối',
                        subtitle: 'Dark mode',
                        value: themeProv.isDark,
                        onChanged: (_) => themeProv.toggle(),
                      ),
                      const _ItemDiv(),
                      _ToggleRow(
                        icon: Icons.notifications_outlined,
                        iconColor: const Color(0xFF22C55E),
                        title: 'Thông báo',
                        subtitle: 'Cảnh báo, sự kiện lái xe',
                        value: _notifEnabled,
                        onChanged: (v) => setState(() => _notifEnabled = v),
                      ),
                    ]),
                  ]),
                ),
              ),

              // ── Sign out ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Tài Khoản'),
                    const SizedBox(height: 12),
                    _SettingsCard(children: [
                      _ActionRow(
                        icon: Icons.info_outline_rounded,
                        iconColor: _sub,
                        title: 'Về ứng dụng',
                        subtitle: 'ADAS Platform v3.0 PRO',
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _signOut,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.35)),
                          boxShadow: [BoxShadow(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                              blurRadius: 16, offset: const Offset(0, 4))],
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                          Icon(Icons.logout_rounded,
                              size: 20, color: Color(0xFFEF4444)),
                          SizedBox(width: 10),
                          Text('Đăng xuất',
                              style: TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFEF4444))),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: Color(0xFF888888), letterSpacing: 0.5));
}

// ─── Settings card ────────────────────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _border),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16, offset: const Offset(0, 4))],
    ),
    child: Column(children: children),
  );
}

class _ItemDiv extends StatelessWidget {
  const _ItemDiv();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: _border, indent: 60);
}

// ─── Toggle row ───────────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.icon, required this.iconColor,
      required this.title, required this.subtitle,
      required this.value, required this.onChanged});
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
    child: Row(children: [
      Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(title, style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.w500, color: _ink)),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: _sub)),
      ])),
      Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: _accent,
        activeTrackColor: _accent.withValues(alpha: 0.30),
      ),
    ]),
  );
}

// ─── Action row ───────────────────────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.iconColor,
      required this.title, required this.subtitle, this.onTap});
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(title, style: const TextStyle(fontSize: 14,
              fontWeight: FontWeight.w500, color: _ink)),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: _sub)),
        ])),
        const Icon(Icons.chevron_right_rounded, size: 20, color: _sub),
      ]),
    ),
  );
}
