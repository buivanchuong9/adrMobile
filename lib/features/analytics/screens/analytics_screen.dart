import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích đội xe'), // Vietnamese
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreCard(context),
            const SizedBox(height: 24),
            _buildChartSection(
              context, 
              title: 'Xu hướng điểm an toàn', 
              subtitle: '30 ngày qua',
              color: AppColors.primary,
              height: 200,
            ),
             const SizedBox(height: 24),
            _buildChartSection(
              context, 
              title: 'Tổng quãng đường', 
              subtitle: 'Km hằng ngày',
              color: AppColors.success,
              height: 200,
            ),
             const SizedBox(height: 24),
            _buildBarChartSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.black, // Premium Black
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Điểm An Toàn Đội Xe',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '94/100',
                style: TextStyle(
                  color: AppColors.premiumOrange, // Orange Accent
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '+2.5% so với tháng trước',
                style: TextStyle(
                  color: Colors.white70, 
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: AppColors.premiumOrange, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, {required String title, required String subtitle, required Color color, required double height}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         border: Border.all(color: AppColors.backgroundSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          SizedBox(
            height: height * 0.7,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                // Simulate random data
                final double h = (index * 15 + 40) % 100 + 20; 
                return Container(
                  width: 30,
                  height: h,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: h * 0.8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('T2', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('T3', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('T4', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('T5', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('T6', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('T7', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('CN', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBarChartSection(BuildContext context) {
      return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         border: Border.all(color: AppColors.backgroundSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tần suất cảnh báo', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          _buildBarRow('Va chạm phía trước', 0.8, AppColors.error),
          const SizedBox(height: 16),
          _buildBarRow('Buồn ngủ', 0.5, AppColors.warning),
          const SizedBox(height: 16),
          _buildBarRow('Lệch làn', 0.3, AppColors.success),
        ],
      ),
      );
  }

  Widget _buildBarRow(String label, double pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundSubtle,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
             LayoutBuilder(
               builder: (context, constraints) {
                 return Container(
                  height: 10,
                  width: constraints.maxWidth * pct,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                             );
               }
             ),
          ],
        ),
      ],
    );
  }
}
