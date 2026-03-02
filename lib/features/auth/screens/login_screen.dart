import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import '../../../core/services/auth_service.dart';
import '../../../main.dart' show iosSlide;
import 'register_screen.dart';
import '../../home/screens/main_shell.dart';

const _bg     = Color(0xFFF5F5F5);
const _card   = Color(0xFFFFFFFF);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool   _obscure = true;
  bool   _loading = false;
  String _error   = '';
  final  _emailCtrl = TextEditingController();
  final  _passCtrl  = TextEditingController();

  // Sample chart data – replaced by real API data once user logs in
  final List<Map<String, dynamic>> _chartData = const [];

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _onLogin() async {
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Vui lòng nhập đầy đủ thông tin');
      return;
    }
    setState(() { _loading = true; _error = ''; });
    HapticFeedback.mediumImpact();
    try {
      await AuthService.signIn(email, pass);
      if (!mounted) return;
      Navigator.pushReplacement(context, iosSlide(const MainShell()));
    } catch (e) {
      setState(() {
        _error   = AuthService.mapError(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52),

                Center(
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: _ink, borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: const Icon(Icons.directions_car_filled_rounded, color: _accent, size: 34),
                  ),
                ),
                const SizedBox(height: 28),

                const Text('ADAS', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        letterSpacing: 4, color: _accent)),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text('Chào mừng trở lại', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800,
                          color: _ink, height: 1.1, letterSpacing: -0.8)),
                ),
                const SizedBox(height: 8),
                const Text('Đăng nhập để tiếp tục', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: _sub)),
                const SizedBox(height: 36),

                // ── Grouped card form ─────────────────────────────────────
                _FormCard(children: [
                  _IosField(ctrl: _emailCtrl, hint: 'Email',
                      icon: Icons.mail_outline_rounded,
                      inputType: TextInputType.emailAddress),
                  const _FieldDivider(),
                  _IosField(ctrl: _passCtrl, hint: 'Mật khẩu',
                      icon: Icons.lock_outline_rounded, obscure: _obscure,
                      suffix: _EyeBtn(v: _obscure,
                          onTap: () => setState(() => _obscure = !_obscure))),
                ]),
                const SizedBox(height: 10),

                // ── Error message ─────────────────────────────────────────
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(_error, textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13,
                            color: Color(0xFFEF4444), fontWeight: FontWeight.w500)),
                  ),

                Align(alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text('Quên mật khẩu?',
                          style: TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w600, color: _accent)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _PrimaryBtn(label: 'Đăng nhập', loading: _loading,
                    onTap: _loading ? null : _onLogin),
                const SizedBox(height: 20),

                _GhostBtn(label: 'Đăng nhập bằng Face ID',
                    icon: Icons.face_retouching_natural_outlined,
                    onTap: () => HapticFeedback.selectionClick()),
                const SizedBox(height: 40),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Chưa có tài khoản?  ',
                      style: TextStyle(fontSize: 14, color: _sub)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context, iosSlide(const RegisterScreen())),
                    child: const Text('Đăng ký',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700, color: _accent)),
                  ),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

// ─── Form card ────────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _border),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 20, offset: const Offset(0, 4))],
    ),
    child: Column(children: children),
  );
}

class _FieldDivider extends StatelessWidget {
  const _FieldDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: _border, indent: 52);
}

class _IosField extends StatelessWidget {
  const _IosField({required this.ctrl, required this.hint, required this.icon,
      this.obscure = false, this.inputType, this.suffix});
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? inputType;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: Row(children: [
      const SizedBox(width: 18),
      Icon(icon, size: 19, color: _sub),
      const SizedBox(width: 14),
      Expanded(
        child: TextField(
          controller: ctrl, obscureText: obscure, keyboardType: inputType,
          style: const TextStyle(fontSize: 16, color: _ink),
          onSubmitted: (_) {},
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 16, color: _sub),
            border: InputBorder.none, enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none, filled: false,
            isDense: true, contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
      if (suffix != null) suffix!,
    ]),
  );
}

class _EyeBtn extends StatelessWidget {
  const _EyeBtn({required this.v, required this.onTap});
  final bool v;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Icon(v ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20, color: _sub),
    ),
  );
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn({required this.label, this.onTap, this.loading = false});
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: _accent, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.35),
            blurRadius: 20, offset: const Offset(0, 7))],
      ),
      child: loading
          ? const Center(child: SizedBox(width: 22, height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)))
          : Center(child: Text(label, style: const TextStyle(fontSize: 16,
              fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.2))),
    ),
  );
}

class _GhostBtn extends StatelessWidget {
  const _GhostBtn({required this.label, required this.icon, this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 54,
      decoration: BoxDecoration(
        color: _card, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 20, color: _ink),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 15,
            fontWeight: FontWeight.w600, color: _ink)),
      ]),
    ),
  );
}

@Preview(name: 'Login')
Widget previewLoginScreen() =>
    const MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
