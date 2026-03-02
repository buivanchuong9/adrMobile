import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/clean_theme_2026.dart';
import '../analytics/presentation/analytics_screen.dart';
import '../settings/presentation/settings_screen.dart';
import '../events/presentation/event_log_screen.dart';

/// 📱 Modern 2026 Dashboard - Clean, Professional & Commercial
/// Fixes all layout issues with responsive design
class ModernDashboardScreen extends StatefulWidget {
  const ModernDashboardScreen({super.key});

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedBottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AutomotiveTheme.neutralGray100,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernHeader(),
              Gap(24.h),
              _buildStatsGrid(),
              Gap(24.h),
              _buildQuickActions(),
              Gap(24.h),
              _buildRecentActivity(),
              Gap(100.h), // Bottom navigation space
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(),
      floatingActionButton: _buildUploadFAB(),
    );
  }

  /// 🎨 Modern Clean Header - Fixed Layout
  Widget _buildModernHeader() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(24.w),
      decoration: AutomotiveTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Responsive
          Row(
            children: [
              // Logo & Title - Flexible sizing
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: AutomotiveTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.analytics_rounded,
                        color: AutomotiveTheme.primaryWhite,
                        size: 24.w,
                      ),
                    ),
                    Gap(12.w),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'ADAS PRO',
                            style: AutomotiveTheme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AutomotiveTheme.primaryBlack,
                            ),
                            maxLines: 1,
                            minFontSize: 16,
                          ),
                          AutoSizeText(
                            'Video Analytics Dashboard',
                            style: AutomotiveTheme.textTheme.bodyMedium?.copyWith(
                              color: AutomotiveTheme.neutralGray700,
                            ),
                            maxLines: 1,
                            minFontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notification Icon
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AutomotiveTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: AutomotiveTheme.primaryOrange,
                  size: 20.w,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0);
  }

  /// 📊 Clean Stats Grid - Responsive & No Overflow
  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                '12',
                'Active Videos',
                AutomotiveTheme.primaryBlue,
                Icons.play_circle_filled_rounded,
                0,
              ),
              _buildStatCard(
                '48',
                'Completed',
                AutomotiveTheme.primaryGreen,
                Icons.check_circle_rounded,
                1,
              ),
              _buildStatCard(
                '3',
                'Processing',
                AutomotiveTheme.primaryOrange,
                Icons.hourglass_empty_rounded,
                2,
              ),
              _buildStatCard(
                '2',
                'Alerts',
                AutomotiveTheme.primaryRed,
                Icons.warning_rounded,
                3,
              ),
            ],
          );
        },
      ),
    );
  }

  /// 📊 Individual Stat Card - Clean Design
  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    IconData icon,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AutomotiveTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Value Row
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18.w,
                ),
              ),
              const Spacer(),
              AutoSizeText(
                value,
                style: AutomotiveTheme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                maxLines: 1,
                minFontSize: 18,
              ),
            ],
          ),
          Gap(8.h),
          AutoSizeText(
            label,
            style: AutomotiveTheme.textTheme.bodyMedium?.copyWith(
              color: AutomotiveTheme.neutralGray700,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            minFontSize: 12,
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }

  /// 🚀 Quick Actions - Modern Button Design  
  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Quick Actions',
            style: AutomotiveTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AutomotiveTheme.primaryBlack,
            ),
            maxLines: 1,
          ),
          Gap(16.h),
          
          // Action Buttons - Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.5,
                children: [
                  _buildActionButton(
                    'Upload Video',
                    Icons.upload_rounded,
                    AutomotiveTheme.primaryBlue,
                    () => _showUploadDialog(),
                  ),
                  _buildActionButton(
                    'Video Library',
                    Icons.video_library_rounded,
                    AutomotiveTheme.primaryGreen,
                    () {}, // Navigate to library
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  /// 🎯 Action Button - Clean Design
  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AutomotiveTheme.primaryWhite,
                size: 18.w,
              ),
              Gap(8.w),
              Flexible(
                child: AutoSizeText(
                  title,
                  style: AutomotiveTheme.textTheme.labelMedium?.copyWith(
                    color: AutomotiveTheme.primaryWhite,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  minFontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📋 Recent Activity - Clean List
  Widget _buildRecentActivity() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Recent Activity',
            style: AutomotiveTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AutomotiveTheme.primaryBlack,
            ),
            maxLines: 1,
          ),
          Gap(16.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: AutomotiveTheme.cardDecoration,
            child: Column(
              children: [
                _buildActivityItem(
                  'Video processed successfully',
                  'highway_clip_001.mp4',
                  '2 min ago',
                  AutomotiveTheme.primaryGreen,
                  Icons.check_circle_rounded,
                ),
                Divider(
                  height: 24.h,
                  color: AutomotiveTheme.borderLight,
                ),
                _buildActivityItem(
                  'Analysis in progress',
                  'traffic_junction.mp4',
                  '5 min ago',
                  AutomotiveTheme.primaryOrange,
                  Icons.hourglass_empty_rounded,
                ),
                Divider(
                  height: 24.h,
                  color: AutomotiveTheme.borderLight,
                ),
                _buildActivityItem(
                  'New upload started',
                  'city_drive.mp4',
                  '12 min ago',
                  AutomotiveTheme.primaryBlue,
                  Icons.upload_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  /// 📝 Activity Item
  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16.w,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                title,
                style: AutomotiveTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AutomotiveTheme.primaryBlack,
                ),
                maxLines: 1,
                minFontSize: 12,
              ),
              AutoSizeText(
                subtitle,
                style: AutomotiveTheme.textTheme.bodySmall?.copyWith(
                  color: AutomotiveTheme.neutralGray600,
                ),
                maxLines: 1,
                minFontSize: 10,
              ),
            ],
          ),
        ),
        AutoSizeText(
          time,
          style: AutomotiveTheme.textTheme.bodySmall?.copyWith(
            color: AutomotiveTheme.neutralGray500,
          ),
          maxLines: 1,
          minFontSize: 10,
        ),
      ],
    );
  }

  /// 📱 Modern Bottom Navigation
  Widget _buildModernBottomNav() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AutomotiveTheme.primaryWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AutomotiveTheme.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
          _buildNavItem(Icons.analytics_rounded, 'Analytics', 1),
          _buildNavItem(Icons.history_rounded, 'History', 2),
          _buildNavItem(Icons.settings_rounded, 'Settings', 3),
        ],
      ),
    );
  }

  /// 📍 Nav Item
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedBottomIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AutomotiveTheme.primaryBlue.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AutomotiveTheme.primaryBlue
                    : AutomotiveTheme.neutralGray600,
                size: 20.w,
              ),
            ),
            Gap(4.h),
            AutoSizeText(
              label,
              style: AutomotiveTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AutomotiveTheme.primaryBlue
                    : AutomotiveTheme.neutralGray600,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              maxLines: 1,
              minFontSize: 8,
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 Upload FAB
  Widget _buildUploadFAB() {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AutomotiveTheme.primaryBlue,
            AutomotiveTheme.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AutomotiveTheme.primaryBlue.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showUploadDialog,
          borderRadius: BorderRadius.circular(16.r),
          child: Icon(
            Icons.video_call_rounded,
            color: AutomotiveTheme.primaryWhite,
            size: 24.w,
          ),
        ),
      ),
    );
  }

  /// 📱 Navigation Handler
  void _onNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventLogScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  /// 📤 Upload Dialog
  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: AutomotiveTheme.primaryWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Gap(12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AutomotiveTheme.neutralGray300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(24.h),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  AutoSizeText(
                    'Upload Video',
                    style: AutomotiveTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                  Gap(24.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadOption(
                          'Camera',
                          Icons.camera_alt_rounded,
                          AutomotiveTheme.primaryBlue,
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        child: _buildUploadOption(
                          'Gallery',
                          Icons.photo_library_rounded,
                          AutomotiveTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📤 Upload Option
  Widget _buildUploadOption(String title, IconData icon, Color color) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            // Handle upload logic
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 32.w,
              ),
              Gap(8.h),
              AutoSizeText(
                title,
                style: AutomotiveTheme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alias for backward compatibility
typedef DashboardScreen = ModernDashboardScreen;