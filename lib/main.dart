import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/constants.dart';
import 'core/services/auth_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/security_lock_screen.dart';
import 'features/home/screens/main_shell.dart';
import 'providers/driving_analysis_provider.dart';
import 'providers/driver_monitoring_provider.dart';
import 'providers/log_stream_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase ──────────────────────────────────────────────────────────────
  await Supabase.initialize(
    url:     AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // ── System UI ─────────────────────────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // ── Restore session ───────────────────────────────────────────────────────
  final hasSession = await AuthService.restoreSession();

  runApp(AdasApp(startAuthenticated: hasSession));
}

class AdasApp extends StatefulWidget {
  const AdasApp({super.key, required this.startAuthenticated});
  final bool startAuthenticated;

  @override
  State<AdasApp> createState() => _AdasAppState();
}

class _AdasAppState extends State<AdasApp> with WidgetsBindingObserver {
  DateTime? _lastBackground;
  bool      _showLock = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastBackground = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_lastBackground != null && AuthService.isAuthenticated) {
        final diff = DateTime.now().difference(_lastBackground!);
        if (diff.inSeconds > AppConstants.lockAfterSeconds) {
          setState(() => _showLock = true);
        }
      }
      _lastBackground = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DrivingAnalysisProvider()),
        ChangeNotifierProvider(create: (_) => DriverMonitoringProvider()),
        ChangeNotifierProvider(create: (_) => LogStreamProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProv, __) => ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (_, __) => MaterialApp(
            title: 'ADAS Platform',
            debugShowCheckedModeBanner: false,
            themeMode: themeProv.themeMode,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            home: _buildHome(),
            builder: (ctx, child) => MediaQuery(
              data: MediaQuery.of(ctx).copyWith(
                  textScaler: const TextScaler.linear(1.0)),
              child: child!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome() {
    if (_showLock) {
      return SecurityLockScreen(
        onUnlocked: () => setState(() => _showLock = false));
    }
    return widget.startAuthenticated
        ? const MainShell()
        : const LoginScreen();
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF97316),
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isLight
          ? const Color(0xFFF5F5F5)
          : const Color(0xFF0F1219),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
        },
      ),
      splashFactory:    NoSplash.splashFactory,
      splashColor:      Colors.transparent,
      highlightColor:   Colors.transparent,
      cardTheme: CardThemeData(
        color:     isLight ? Colors.white : const Color(0xFF1C1F2D),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: isLight
              ? const Color(0xFFEAEAEA) : const Color(0xFF2A2D3E)),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}

// ── Shared iOS-slide route helper ─────────────────────────────────────────────
Route<T> iosSlide<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: child,
    ),
    transitionDuration:        const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
  );
}
