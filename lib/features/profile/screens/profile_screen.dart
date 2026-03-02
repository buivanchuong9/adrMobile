import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/auth_service.dart';
import '../../../main.dart' show iosSlide;
import '../../auth/screens/login_screen.dart';

const _bg     = Color(0xFFF5F5F5);
const _card   = Color(0xFFFFFFFF);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _signOut(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.w700)),
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
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    await AuthService.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context, iosSlide(const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
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

              // ── Back / header ─────────────────────────────────────────────
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
                    const Text('Hồ Sơ', style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w700, color: _ink)),
                    const Spacer(),
                    const SizedBox(width: 38),
                  ]),
                ),
              ),

              // ── Avatar + name card ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _ink,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 28, offset: const Offset(0, 10))],
                    ),
                    child: Column(children: [
                      // Avatar circle
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.4),
                              blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: Center(
                          child: Text(_initials(name),
                              style: const TextStyle(fontSize: 28,
                                  fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(name, style: const TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(email, style: TextStyle(fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.55))),
                      const SizedBox(height: 20),
                      // Stats row
                      Row(children: [
                        _buildStat('v3.0', 'Phiên bản'),
                        _vDivider(),
                        _buildStat('PRO', 'Gói dịch vụ'),
                        _vDivider(),
                        _buildStat('ADAS', 'Hệ thống'),
                      ]),
                    ]),
                  ),
                ),
              ),

              // ── Info section ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const _SectionLabel('Thông Tin Tài Khoản'),
                    const SizedBox(height: 12),
                    _InfoCard(children: [
                      _InfoRow(icon: Icons.person_outline_rounded,
                          label: 'Họ và tên', value: name),
                      const _ItemDivider(),
                      _InfoRow(icon: Icons.mail_outline_rounded,
                          label: 'Email', value: email),
                      const _ItemDivider(),
                      _InfoRow(icon: Icons.shield_outlined,
                          label: 'Vai trò', value: 'Tài xế / Admin'),
                    ]),
                  ]),
                ),
              ),

              // ── Actions ───────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const _SectionLabel('Hành Động'),
                    const SizedBox(height: 12),
                    _InfoCard(children: [
                      _ActionRow(
                        icon: Icons.edit_outlined, label: 'Chỉnh sửa hồ sơ',
                        color: _accent,
                        onTap: () => HapticFeedback.selectionClick(),
                      ),
                      const _ItemDivider(),
                      _ActionRow(
                        icon: Icons.lock_reset_rounded, label: 'Đổi mật khẩu',
                        color: const Color(0xFF6366F1),
                        onTap: () => HapticFeedback.selectionClick(),
                      ),
                    ]),
                  ]),
                ),
              ),

              // ── Sign-out ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
                  child: GestureDetector(
                    onTap: () => _signOut(context),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                        boxShadow: [BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                            blurRadius: 16, offset: const Offset(0, 4))],
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.logout_rounded,
                            size: 20, color: Color(0xFFEF4444)),
                        const SizedBox(width: 10),
                        const Text('Đăng xuất',
                            style: TextStyle(fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEF4444))),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) => Expanded(
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.w800, color: Colors.white)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontSize: 10,
          color: Colors.white.withValues(alpha: 0.5))),
    ]),
  );

  Widget _vDivider() => Container(
      width: 1, height: 32,
      color: Colors.white.withValues(alpha: 0.12));
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: Color(0xFF888888), letterSpacing: 0.5));
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
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

class _ItemDivider extends StatelessWidget {
  const _ItemDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: _border, indent: 52);
}

// ─── Info Row ─────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    child: Row(children: [
      Icon(icon, size: 19, color: _sub),
      const SizedBox(width: 14),
      Expanded(child: Text(label,
          style: const TextStyle(fontSize: 14, color: _sub))),
      Text(value, style: const TextStyle(fontSize: 14,
          fontWeight: FontWeight.w600, color: _ink)),
    ]),
  );
}

// ─── Action Row ───────────────────────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label,
      required this.color, this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label,
            style: const TextStyle(fontSize: 14,
                fontWeight: FontWeight.w500, color: _ink))),
        const Icon(Icons.chevron_right_rounded, size: 20, color: _sub),
      ]),
    ),
  );
}
