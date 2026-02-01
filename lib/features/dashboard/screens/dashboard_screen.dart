import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/alert_card.dart';
import '../../settings/screens/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.backgroundSubtle,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, Admin',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Hệ thống ổn định • 45 Xe đang hoạt động',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () {
               Navigator.of(context).push(
                 MaterialPageRoute(builder: (context) => const SettingsScreen()),
               );
            },
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gantt Chart Section (Highcharts Style)
            Text(
              'Tiến độ vận hành (Gantt)',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            _buildGanttChart(context),
            const SizedBox(height: 24),

            // 3D Chart Section
             Text(
              'Thống kê hiệu suất (3D)',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            _build3DChart(context),
            const SizedBox(height: 24),

            // Map Snippet
            Text(
              'Tổng quan đội xe',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.backgroundSubtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.backgroundSubtle),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.map, size: 64, color: Colors.grey[400]),
                  ),
                  const Positioned(
                    top: 80, left: 150,
                    child: Icon(Icons.location_on, color: AppColors.premiumOrange, size: 40),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: FloatingActionButton.small(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      onPressed: () {},
                      child: const Icon(Icons.open_in_full),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Critical Alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cảnh báo gần đây',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            const AlertCard(
              vehicleId: '59B1-123.45',
              eventType: 'Phát hiện buồn ngủ',
              time: '2 phút trước',
              isHighPriority: true,
            ),
            const AlertCard(
              vehicleId: '29H-999.99',
              eventType: 'Cảnh báo va chạm',
              time: '15 phút trước',
              isHighPriority: true,
            ),
          ],
        ),
      ),
    );
  }

  // Simulated Highcharts Gantt
  Widget _buildGanttChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildGanttRow('Xe 01', 0.2, 0.6, AppColors.premiumOrange),
          const SizedBox(height: 12),
          _buildGanttRow('Xe 02', 0.0, 0.4, AppColors.success),
          const SizedBox(height: 12),
          _buildGanttRow('Xe 03', 0.5, 0.9, AppColors.accent),
          const SizedBox(height: 12),
          _buildGanttRow('Xe 04', 0.3, 0.7, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildGanttRow(String label, double startPct, double endPct, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.backgroundSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    final double left = width * startPct;
                    final double itemWidth = width * (endPct - startPct);
                    return Positioned(
                      left: left,
                      width: itemWidth,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Simulated 3D Bar Chart
  Widget _build3DChart(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFFF0F4F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _build3DBar(height: 100, color: AppColors.premiumOrange, label: 'T2'),
          _build3DBar(height: 140, color: AppColors.accent, label: 'T3'),
          _build3DBar(height: 80, color: AppColors.success, label: 'T4'),
          _build3DBar(height: 160, color: AppColors.error, label: 'T5'),
          _build3DBar(height: 120, color: AppColors.warning, label: 'T6'),
        ],
      ),
    );
  }

  Widget _build3DBar({required double height, required Color color, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Side Face (Depth)
            Transform(
              transform: Matrix4.skewY(0.0)..translate(8.0, 0.0), // Simple fake 3D
              child: Container(
                width: 10,
                height: height - 5,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.6), // Darker side
                ),
              ),
            ),
            // Front Face
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                boxShadow: const [
                   BoxShadow(
                     color: Colors.black12,
                     blurRadius: 4,
                     offset: Offset(4, 4),
                   )
                ],
              ),
            ),
            // Top Face (Lid)
            Positioned(
              top: 0,
              child: Container(
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }
}
