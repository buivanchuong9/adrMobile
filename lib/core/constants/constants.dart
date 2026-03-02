// ── App Constants ─────────────────────────────────────────────────────────────
class AppConstants {
  // Supabase
  static const supabaseUrl    = 'https://kijdjdtuyeywmthhuoac.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpamRqZHR1eWV5d210aGh1b2FjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczMzY0MTUsImV4cCI6MjA4MjkxMjQxNX0'
      '.T2UOrxb53Op_xfMMoaTvQIUs0c_PJbPdlezz4B1-9Lg';

  // ADAS API
  static const adasBaseUrl     = 'https://adas-api.aiotlab.edu.vn';
  static const uploadTimeout   = Duration(seconds: 240);
  static const pollInterval    = Duration(seconds: 2);

  // Secure storage
  static const tokenKey        = 'access_token';

  // SharedPreferences
  static const themePrefKey    = 'isDarkMode';

  // Security
  static const lockAfterSeconds = 30;

  // Max log entries in memory
  static const maxLogEntries   = 500;
}
