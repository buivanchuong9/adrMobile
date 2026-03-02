import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import '../../../core/services/auth_service.dart';
import '../../../main.dart' show iosSlide;
import '../../home/screens/main_shell.dart';

const _bg     = Color(0xFFF5F5F5);
const _card   = Color(0xFFFFFFFF);
const _border = Color(0xFFEAEAEA);
const _ink    = Color(0xFF111111);
const _sub    = Color(0xFF888888);
const _accent = Color(0xFFF97316);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool   _obscureP = true, _obscureC = true, _loading = false;
  String _error    = '';
  final  _email   = TextEditingController();
  final  _pass    = TextEditingController();
  final  _confirm = TextEditingController();
  final  _name    = TextEditingController();

  @override
  void dispose() {
    _email.dispose(); _pass.dispose(); _confirm.dispose(); _name.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final email = _email.text.trim();
    final pass  = _pass.text;
    final conf  = _confirm.text;
    final name  = _name.text.trim();

    if (email.isEmpty || pass.isEmpty || name.isEmpty) {
      setState(() => _error = 'Vui lòng nhập đầy đủ thông tin');
      return;
    }
    if (pass.length < 6) {
      setState(() => _error = 'Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }
    if (pass != conf) {
      setState(() => _error = 'Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() { _loading = true; _error = ''; });
    HapticFeedback.mediumImpact();
    try {
      await AuthService.signUp(email, pass, name);
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
                const SizedBox(height: 48),

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
                const SizedBox(height: 26),

                const Text('ADAS', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        letterSpacing: 4, color: _accent)),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text('Tạo tài khoản', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800,
                          color: _ink, height: 1.1, letterSpacing: -0.8)),
                ),
                const SizedBox(height: 8),
                const Text('Bắt đầu hành trình an toàn', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: _sub)),
                const SizedBox(height: 32),

                _FormCard(children: [
                  _IosField(ctrl: _email, hint: 'Email',
                      icon: Icons.mail_outline_rounded,
                      inputType: TextInputType.emailAddress),
                  const _FieldDivider(),
                  _IosField(ctrl: _pass, hint: 'Mật khẩu',
                      icon: Icons.lock_outline_rounded, obscure: _obscureP,
                      suffix: _EyeBtn(v: _obscureP,
                          onTap: () => setState(() => _obscureP = !_obscureP))),
                  const _FieldDivider(),
                  _IosField(ctrl: _confirm, hint: 'Xác nhận mật khẩu',
                      icon: Icons.lock_outline_rounded, obscure: _obscureC,
                      suffix: _EyeBtn(v: _obscureC,
                          onTap: () => setState(() => _obscureC = !_obscureC))),
                  const _FieldDivider(),
                  _IosField(ctrl: _name, hint: 'Họ và tên',
                      icon: Icons.person_outline_rounded),
                ]),

                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error, textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13,
                            color: Color(0xFFEF4444), fontWeight: FontWeight.w500)),
                  ),
                const SizedBox(height: 24),

                _PrimaryBtn(label: 'Đăng ký', loading: _loading,
                    onTap: _loading ? null : _onRegister),
                const SizedBox(height: 32),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Đã có tài khoản?  ',
                      style: TextStyle(fontSize: 14, color: _sub)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Đăng nhập',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700, color: _accent)),
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────
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
      const SizedBox(width: 18), Icon(icon, size: 19, color: _sub),
      const SizedBox(width: 14),
      Expanded(
        child: TextField(
          controller: ctrl, obscureText: obscure, keyboardType: inputType,
          style: const TextStyle(fontSize: 16, color: _ink),
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

@Preview(name: 'Register')
Widget previewRegisterScreen() =>
    const MaterialApp(debugShowCheckedModeBanner: false, home: RegisterScreen());
