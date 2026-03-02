import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SecurityLockScreen extends StatefulWidget {
  const SecurityLockScreen({super.key, required this.onUnlocked});
  final VoidCallback onUnlocked;
  @override
  State<SecurityLockScreen> createState() => _SecurityLockScreenState();
}

class _SecurityLockScreenState extends State<SecurityLockScreen> {
  final _auth = LocalAuthentication();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    setState(() { _loading = true; _error = null; });
    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Mở khóa ADAS App',
        options: const AuthenticationOptions(biometricOnly: false),
      );
      if (ok && mounted) widget.onUnlocked();
      else if (mounted) setState(() { _error = 'Xác thực không thành công'; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Lỗi sinh trắc học: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Lock icon
                Container(
                  width: 88, height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.20),
                        blurRadius: 28, offset: const Offset(0, 10))],
                  ),
                  child: const Icon(Icons.lock_rounded, color: Color(0xFFF97316), size: 40),
                ),
                const SizedBox(height: 32),

                const Text('ADAS', style: TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 4, color: Color(0xFFF97316))),
                const SizedBox(height: 12),
                const Text('Tự động khóa', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                        color: Color(0xFF111111), letterSpacing: -0.6)),
                const SizedBox(height: 10),
                const Text('Ứng dụng đã bị khóa do không hoạt động.\nVui lòng xác thực để tiếp tục.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFF888888), height: 1.5)),
                const SizedBox(height: 48),

                // Unlock button
                GestureDetector(
                  onTap: _loading ? null : _authenticate,
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: const Color(0xFFF97316).withValues(alpha: 0.35),
                          blurRadius: 20, offset: const Offset(0, 7))],
                    ),
                    child: _loading
                        ? const Center(child: SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)))
                        : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.fingerprint, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text('Mở khóa bằng Sinh Trắc Học',
                                style: TextStyle(fontSize: 15,
                                    fontWeight: FontWeight.w700, color: Colors.white)),
                          ]),
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Color(0xFFEF4444))),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
