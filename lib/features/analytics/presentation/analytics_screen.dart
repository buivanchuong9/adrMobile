import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart' as animate_do;
import '../../../core/theme/modern_theme_2026.dart';
import '../../../core/widgets/automotive_widgets.dart';

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

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _gaugeController;
  
  int selectedTimeframe = 0; // 0: Today, 1: Week, 2: Month
  double processingEfficiency = 85.5;
  double accuracyRate = 94.7;
  double systemLoad = 68.2;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _gaugeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _chartController.forward();
    _gaugeController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    _gaugeController.dispose();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeframeSelector(),
                      const SizedBox(height: 24),
                      _buildKPIGauges(),
                      const SizedBox(height: 24),
                      _buildProcessingChart(),
                      const SizedBox(height: 24),
                      _buildAccuracyTrends(),
                      const SizedBox(height: 24),
                      _buildSystemMetrics(),
                      const SizedBox(height: 24),
                      _buildDetectionAnalysis(),
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
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _kBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _kInk),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _kInk)),
                  SizedBox(height: 1),
                  Text('Performance dashboard', style: TextStyle(fontSize: 12, color: _kMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _kBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kBlue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 7, height: 7,
                      decoration: BoxDecoration(color: _kGreen, shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: _kGreen.withOpacity(0.5), blurRadius: 5)])),
                  const SizedBox(width: 5),
                  const Text('Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _kGreen)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    final timeframes = ['Today', 'This Week', 'This Month'];
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _kSurf,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: List.generate(timeframes.length, (index) {
            final isSelected = selectedTimeframe == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => selectedTimeframe = index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? _kBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    timeframes[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : _kMuted,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildKPIGauges() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Row(
        children: [
          Expanded(child: _buildKPIGauge('Processing\nEfficiency', processingEfficiency, AutomotiveTheme.corporateBlue)),
          const SizedBox(width: 16),
          Expanded(child: _buildKPIGauge('Accuracy\nRate', accuracyRate, AutomotiveTheme.businessGreen)),
          const SizedBox(width: 16),
          Expanded(child: _buildKPIGauge('System\nLoad', systemLoad, AutomotiveTheme.businessOrange)),
        ],
      ),
    );
  }

  Widget _buildKPIGauge(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: _kSurf,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: AnimatedSpeedGauge(
        value: value,
        label: title,
        color: color,
        size: 80,
      ),
    );
  }

  Widget _buildProcessingChart() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 550),
      child: Container(
        height: 250,
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
              const Text('Processing Timeline',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _kInk)),
              const SizedBox(height: 4),
              const Text('Hourly video processing load',
                  style: TextStyle(fontSize: 11, color: _kMuted)),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final hours = ['00', '04', '08', '12', '16', '20', '24'];
                            if (value.toInt() < hours.length) {
                              return Text(
                                hours[value.toInt()],
                                style: TextStyle(color: AutomotiveTheme.textGray, fontSize: 12),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (_) => FlLine(color: _kBorder, strokeWidth: 1),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 30, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 65, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 85, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 70, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 90, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
                      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 45, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
                      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 20, gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 18, borderRadius: BorderRadius.circular(6))]),
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

  Widget _buildAccuracyTrends() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        height: 200,
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
              const Text('Accuracy Trends',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _kInk)),
              const SizedBox(height: 4),
              const Text('Detection accuracy over time',
                  style: TextStyle(fontSize: 11, color: _kMuted)),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: _kBorder,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 85),
                          FlSpot(1, 88),
                          FlSpot(2, 92),
                          FlSpot(3, 89),
                          FlSpot(4, 94),
                          FlSpot(5, 96),
                          FlSpot(6, 94.7),
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
                        ),
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: const Color(0xFF10B981),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF10B981).withOpacity(0.15),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
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

  Widget _buildSystemMetrics() {
    const metrics = [
      ('CPU Usage', '68%',   Color(0xFF2563EB)),
      ('Memory',    '4.2 GB', Color(0xFFF59E0B)),
      ('GPU Load',  '85%',   Color(0xFF10B981)),
      ('Storage',   '2.8 TB', Color(0xFF14B8A6)),
    ];

    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 650),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: metrics.map((m) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _kSurf,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kBorder),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 6, height: 30,
                  decoration: BoxDecoration(color: m.$3, borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.$2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: m.$3)),
                    Text(m.$1, style: const TextStyle(fontSize: 10, color: _kMuted)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetectionAnalysis() {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        height: 200,
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
              const Text('Detection Categories',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _kInk)),
              const SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(color: const Color(0xFF2563EB), value: 35, title: '35%', radius: 45, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: const Color(0xFF10B981), value: 25, title: '25%', radius: 45, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: const Color(0xFFF59E0B), value: 20, title: '20%', radius: 45, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(color: const Color(0xFF14B8A6), value: 20, title: '20%', radius: 45, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
// ---------------------------------------------------------------------------
// Widget Previews
// ---------------------------------------------------------------------------

@Preview(name: 'AnalyticsScreen')
Widget previewAnalyticsScreen() => MaterialApp(home: const AnalyticsScreen());