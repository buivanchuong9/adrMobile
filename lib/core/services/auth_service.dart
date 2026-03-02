import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/constants.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;
  static const _storage  = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── ĐĂNG KÝ ──────────────────────────────────────────────────────────────
  static Future<void> signUp(String email, String password, String fullName) async {
    if (password.length < 6) throw 'Mật khẩu phải có ít nhất 6 ký tự';

    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    if (res.session == null) {
      throw 'Vui lòng kiểm tra email để xác nhận tài khoản';
    }
    await _storage.write(
        key: AppConstants.tokenKey,
        value: res.session!.accessToken);
  }

  // ── ĐĂNG NHẬP ────────────────────────────────────────────────────────────
  static Future<void> signIn(String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    await _storage.write(
        key: AppConstants.tokenKey,
        value: res.session!.accessToken);
  }

  // ── ĐĂNG XUẤT ────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _storage.delete(key: AppConstants.tokenKey);
  }

  // ── REFRESH SESSION ───────────────────────────────────────────────────────
  static Future<void> refreshSession() async {
    try {
      final res = await _supabase.auth.refreshSession();
      await _storage.write(
          key: AppConstants.tokenKey,
          value: res.session!.accessToken);
    } catch (_) {
      await signOut();
      rethrow;
    }
  }

  // ── RESTORE SESSION khi mở app ────────────────────────────────────────────
  static Future<bool> restoreSession() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    if (token == null) return false;
    try {
      await _supabase.auth.getUser(token);
      return true;
    } catch (_) {
      await _storage.delete(key: AppConstants.tokenKey);
      return false;
    }
  }

  // ── Maps AuthException messages → Vietnamese ──────────────────────────────
  static String mapError(Object e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
        return 'Email hoặc mật khẩu không đúng';
      }
      if (msg.contains('already registered')) return 'Email đã được sử dụng';
      if (msg.contains('network'))           return 'Lỗi kết nối mạng';
      return e.message;
    }
    final str = e.toString().toLowerCase();
    if (str.contains('network') || str.contains('socket')) {
      return 'Lỗi kết nối mạng';
    }
    return e.toString();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  static String?   get accessToken => _supabase.auth.currentSession?.accessToken;
  static User?     get currentUser => _supabase.auth.currentUser;
  static String?   get fullName    => currentUser?.userMetadata?['full_name'];
  static String?   get email       => currentUser?.email;
  static String?   get avatarUrl   => currentUser?.userMetadata?['avatar_url'];
  static bool      get isAuthenticated => currentUser != null;
  static Stream<AuthState> get authChanges => _supabase.auth.onAuthStateChange;
}
