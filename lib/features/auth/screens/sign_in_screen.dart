import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/screens/main_screen.dart';

const _kBlue   = Color(0xFF2563EB);
const _kBg     = Color(0xFFF8FAFC);
const _kSurf   = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE2E8F0);
const _kInk    = Color(0xFF0F172A);
const _kMuted  = Color(0xFF64748B);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscure = true;
  bool _loading = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    HapticFeedback.lightImpact();
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52),

                // ── Brand mark ────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: _kBlue.withOpacity(0.30),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shield_rounded, size: 36, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ADAS PRO',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: _kInk),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fleet Video Analytics Platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: _kMuted, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 44),

                // ── Card ──────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _kSurf,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _kBorder),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Đăng nhập',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _kInk)),
                      const SizedBox(height: 4),
                      const Text('Nhập thông tin tài khoản của bạn',
                          style: TextStyle(fontSize: 12, color: _kMuted)),
                      const SizedBox(height: 24),

                      // Email
                      _FieldLabel(label: 'Email'),
                      const SizedBox(height: 6),
                      _InputField(
                        ctrl: _emailCtrl,
                        hint: 'you@company.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _FieldLabel(label: 'Mật khẩu'),
                      const SizedBox(height: 6),
                      _InputField(
                        ctrl: _passCtrl,
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscure,
                        suffix: GestureDetector(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18, color: _kMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text('Quên mật khẩu?',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _kBlue)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign in button
                      GestureDetector(
                        onTap: _loading ? null : _signIn,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _loading
                                  ? [const Color(0xFF94A3B8), const Color(0xFF94A3B8)]
                                  : [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _loading ? [] : [
                              BoxShadow(color: _kBlue.withOpacity(0.28), blurRadius: 16, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                  )
                                : const Text('Đăng nhập',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Footer ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.4), blurRadius: 6)],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('Kết nối bảo mật SSL', style: TextStyle(fontSize: 11, color: _kMuted)),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Field label ──────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kInk),
  );
}

// ─── Input field ──────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  const _InputField({
    required this.ctrl,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _kBorder),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: _kInk),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: _kMuted),
          prefixIcon: Icon(icon, size: 18, color: _kMuted),
          suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix!) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget Previews
// ---------------------------------------------------------------------------

@Preview(name: 'SignInScreen')
Widget previewSignInScreen() => MaterialApp(home: const SignInScreen());
