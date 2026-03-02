import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:animate_do/animate_do.dart' as animate_do;
import '../../../core/theme/modern_theme_2026.dart';

// Design tokens
const _kBlue   = Color(0xFF2563EB);
const _kGreen  = Color(0xFF10B981);
const _kAmber  = Color(0xFFF59E0B);
const _kTeal   = Color(0xFF14B8A6);
const _kBg     = Color(0xFFF1F5F9);
const _kSurf   = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE2E8F0);
const _kInk    = Color(0xFF0F172A);
const _kMuted  = Color(0xFF64748B);
const _kSubtle = Color(0xFFF8FAFC);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // Settings states
  bool darkModeEnabled = true;
  bool notificationsEnabled = true;
  bool autoAnalysisEnabled = true;
  bool realtimeUpdatesEnabled = true;
  bool bluetoothEnabled = false;
  bool wifiEnabled = true;
  bool locationEnabled = true;
  
  double videoQuality = 80;
  double processingSpeed = 65;
  double batteryOptimization = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Column(
                    children: [
                      _buildSystemSettings(),
                      const SizedBox(height: 16),
                      _buildVideoSettings(),
                      const SizedBox(height: 16),
                      _buildPerformanceSettings(),
                      const SizedBox(height: 16),
                      _buildConnectivitySettings(),
                      const SizedBox(height: 16),
                      _buildAboutSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return animate_do.FadeInDown(
      duration: const Duration(milliseconds: 450),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kSurf,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: _kSubtle,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _kBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _kInk),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _kInk)),
                  Text('System configuration', style: TextStyle(fontSize: 12, color: _kMuted)),
                ],
              ),
            ),
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: _kAmber.withOpacity(0.08),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: _kAmber.withOpacity(0.20)),
              ),
              child: const Icon(Icons.settings_rounded, size: 18, color: _kAmber),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSettings() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: _buildSettingsSection(
        'System Preferences',
        AutomotiveTheme.corporateBlue,
        [
          _buildSwitchTile(
            'Dark Mode',
            'Optimized for automotive displays',
            Icons.dark_mode,
            darkModeEnabled,
            (value) => setState(() => darkModeEnabled = value),
          ),
          _buildSwitchTile(
            'Notifications',
            'Real-time alerts and updates',
            Icons.notifications,
            notificationsEnabled,
            (value) => setState(() => notificationsEnabled = value),
          ),
          _buildSwitchTile(
            'Auto Analysis',
            'Automatic video processing on upload',
            Icons.auto_awesome,
            autoAnalysisEnabled,
            (value) => setState(() => autoAnalysisEnabled = value),
          ),
          _buildSwitchTile(
            'Real-time Updates',
            'Live dashboard data refresh',
            Icons.refresh,
            realtimeUpdatesEnabled,
            (value) => setState(() => realtimeUpdatesEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSettings() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: _buildSettingsSection(
        'Video Configuration',
        AutomotiveTheme.businessGreen,
        [
          _buildSliderTile(
            'Video Quality',
            'Processing quality vs speed balance',
            Icons.high_quality,
            videoQuality,
            (value) => setState(() => videoQuality = value),
            '%',
          ),
          _buildSliderTile(
            'Processing Speed',
            'AI analysis performance setting',
            Icons.speed,
            processingSpeed,
            (value) => setState(() => processingSpeed = value),
            'fps',
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSettings() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: _buildSettingsSection(
        'Performance Tuning',
        AutomotiveTheme.businessOrange,
        [
          _buildSliderTile(
            'Battery Optimization',
            'Power consumption management',
            Icons.battery_charging_full,
            batteryOptimization,
            (value) => setState(() => batteryOptimization = value),
            '%',
          ),
          _buildActionTile(
            'Clear Cache',
            'Free up storage space',
            Icons.cleaning_services,
            () => _showClearCacheDialog(),
          ),
          _buildActionTile(
            'Reset Settings',
            'Restore default configuration',
            Icons.restore,
            () => _showResetDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectivitySettings() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: _buildSettingsSection(
        'Connectivity',
        AutomotiveTheme.businessTeal,
        [
          _buildSwitchTile(
            'Wi-Fi',
            'Wireless network connection',
            Icons.wifi,
            wifiEnabled,
            (value) => setState(() => wifiEnabled = value),
          ),
          _buildSwitchTile(
            'Bluetooth',
            'Device pairing and sync',
            Icons.bluetooth,
            bluetoothEnabled,
            (value) => setState(() => bluetoothEnabled = value),
          ),
          _buildSwitchTile(
            'Location Services',
            'GPS tracking for analytics',
            Icons.location_on,
            locationEnabled,
            (value) => setState(() => locationEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 1400),
      child: _buildSettingsSection(
        'About System',
        AutomotiveTheme.textGray,
        [
          _buildInfoTile('Version', 'ADAS Pro 2.1.0', Icons.info),
          _buildInfoTile('Build', 'Release 2024.01', Icons.build),
          _buildInfoTile('API Level', 'v3.2', Icons.api),
          _buildActionTile(
            'System Diagnostics',
            'Run comprehensive system check',
            Icons.analytics,
            () => _runDiagnostics(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, Color accentColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurf,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4, height: 16,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: _kInk, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: _kSubtle,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _kBorder),
            ),
            child: Icon(icon, color: _kBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: _kInk, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: _kMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) { HapticFeedback.lightImpact(); onChanged(v); },
            activeColor: _kBlue,
            activeTrackColor: _kBlue.withOpacity(0.25),
            inactiveThumbColor: _kMuted,
            inactiveTrackColor: _kBorder,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(String title, String subtitle, IconData icon, double value, Function(double) onChanged, String unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _kSubtle,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _kBorder),
                ),
                child: Icon(icon, color: _kBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 13, color: _kInk, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: _kMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${value.toInt()}$unit',
                  style: const TextStyle(fontSize: 12, color: _kBlue, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _kBlue,
              inactiveTrackColor: _kBorder,
              thumbColor: _kBlue,
              overlayColor: _kBlue.withOpacity(0.12),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              trackHeight: 3,
            ),
            child: Slider(value: value, min: 0, max: 100, onChanged: onChanged),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _kBorder, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _kSubtle,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: _kBorder),
              ),
              child: Icon(icon, color: _kBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, color: _kInk, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: _kMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _kMuted, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: _kSubtle,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _kBorder),
            ),
            child: Icon(icon, color: _kBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 13, color: _kInk, fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _kBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(fontSize: 11, color: _kMuted, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear Cache', style: const TextStyle(color: _kInk, fontWeight: FontWeight.w700)),
        content: Text('This will free up storage space but may temporarily slow down the app.',
            style: const TextStyle(color: _kMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _kMuted)),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kAmber, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Settings', style: TextStyle(color: _kInk, fontWeight: FontWeight.w700)),
        content: const Text('This will restore all settings to their default values.',
            style: TextStyle(color: _kMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _kMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                darkModeEnabled = true;
                notificationsEnabled = true;
                autoAnalysisEnabled = true;
                realtimeUpdatesEnabled = true;
                bluetoothEnabled = false;
                wifiEnabled = true;
                locationEnabled = true;
                videoQuality = 80;
                processingSpeed = 65;
                batteryOptimization = 40;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _runDiagnostics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('System Diagnostics', style: TextStyle(color: _kInk, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: _kGreen),
            const SizedBox(height: 16),
            const Text('Running comprehensive system check...',
                style: TextStyle(color: _kMuted)),
          ],
        ),
      ),
    );
    
    // Close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }
}

// ---------------------------------------------------------------------------
// Widget Previews
// ---------------------------------------------------------------------------

@Preview(name: 'SettingsScreen')
Widget previewSettingsScreen() => MaterialApp(home: const SettingsScreen());