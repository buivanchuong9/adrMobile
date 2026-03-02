import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'adas_dashboard_screen.dart';
import 'driving_analysis_screen.dart';
import 'driver_monitoring_screen.dart';
import '../../events/screens/event_log_screen.dart';

const _accent = Color(0xFFF97316);
const _muted  = Color(0xFFBBBBBB);

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  static const _screens = [
    AdasDashboardScreen(),
    DrivingAnalysisScreen(),
    DriverMonitoringScreen(),
    EventLogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: IndexedStack(index: _idx, children: _screens),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEAEAEA), width: 0.8)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (i) => _buildTab(i)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _navItems = [
    _NavItem(Icons.grid_view_outlined,      Icons.grid_view_rounded,      'Trang Chủ'),
    _NavItem(Icons.directions_car_outlined, Icons.directions_car_filled,   'Lái Xe'),
    _NavItem(Icons.person_outline_rounded,  Icons.person_rounded,          'Tài Xế'),
    _NavItem(Icons.receipt_long_outlined,   Icons.receipt_long_rounded,    'Logs'),
  ];

  Widget _buildTab(int i) {
    final active = _idx == i;
    final item   = _navItems[i];
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _idx = i);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(active ? item.activeIcon : item.icon,
                key: ValueKey(active),
                color: active ? _accent : _muted, size: 25),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              color: active ? _accent : _muted,
            ),
            child: Text(item.label),
          ),
        ]),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
