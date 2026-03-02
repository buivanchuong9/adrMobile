import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A self-contained Highcharts 3D spline chart widget.
/// Supports up to 2 series: primary [dataPoints] and optional [extraSeriesData].
class Highcharts3DWidget extends StatefulWidget {
  const Highcharts3DWidget({
    super.key,
    required this.dataPoints,
    this.title = '',
    this.seriesName = 'Điểm An Toàn',
    this.accentColor = '#F97316',
    this.height = 220.0,
    // Second series (optional)
    this.extraSeriesData,
    this.extraSeriesName,
    this.extraSeriesColor = '#7C3AED',
  });

  final List<Map<String, dynamic>> dataPoints;
  final String title;
  final String seriesName;
  final String accentColor;
  final double height;

  final List<Map<String, dynamic>>? extraSeriesData;
  final String? extraSeriesName;
  final String extraSeriesColor;

  @override
  State<Highcharts3DWidget> createState() => _Highcharts3DWidgetState();
}

class _Highcharts3DWidgetState extends State<Highcharts3DWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(_buildHtml());
  }

  @override
  void didUpdateWidget(Highcharts3DWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataPoints != widget.dataPoints ||
        oldWidget.extraSeriesData != widget.extraSeriesData) {
      _controller.loadHtmlString(_buildHtml());
    }
  }

  String _buildHtml() {
    final yData    = widget.dataPoints.map((p) => p['y'] ?? 0).toList();
    final labels   = widget.dataPoints.asMap().entries.map((e) {
      final p = e.value;
      return p.containsKey('label') ? '"${p['label']}"' : '"${e.key + 1}"';
    }).toList();

    // Build second series JSON if provided
    String extraSeries = '';
    if (widget.extraSeriesData != null && widget.extraSeriesData!.isNotEmpty) {
      final y2 = widget.extraSeriesData!.map((p) => p['y'] ?? 0).toList();
      final name2 = widget.extraSeriesName ?? 'Series 2';
      final col2  = widget.extraSeriesColor;
      extraSeries = ''',{
    name: '$name2',
    data: $y2,
    color: '$col2',
    marker: { fillColor:'#fff', lineColor:'$col2', lineWidth:2, radius:4 },
    lineWidth: 2,
    dashStyle: 'ShortDash',
  }''';
    }

    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  html, body { background:transparent; overflow:hidden; height:100%; }
  #chart { width:100%; height:100%; }
</style>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/highcharts-3d.js"></script>
</head>
<body>
<div id="chart"></div>
<script>
Highcharts.chart('chart', {
  chart: {
    type: 'spline',
    backgroundColor: 'transparent',
    options3d: {
      enabled: true,
      alpha: 8,
      beta: 15,
      depth: 50,
      viewDistance: 30,
    },
    margin: [24, 16, 36, 40],
    animation: { duration: 1200, easing: 'easeInOutQuart' },
    style: { fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif' },
    spacingBottom: 8,
  },
  title: { text: null },
  credits: { enabled: false },
  legend: { enabled: false },
  xAxis: {
    categories: [${labels.join(',')}],
    labels: { style: { color:'#999', fontSize:'10px', fontWeight:'600' } },
    lineColor: '#EBEBEB',
    tickColor: 'transparent',
    gridLineColor: 'transparent',
  },
  yAxis: {
    title: { text: null },
    labels: { style: { color:'#999', fontSize:'9px' } },
    gridLineColor: '#F2F2F2',
    gridLineDashStyle: 'ShortDash',
    min: 50, max: 100,
    tickPositions: [50, 60, 70, 80, 90, 100],
    plotBands: [{
      from: 80, to: 100,
      color: 'rgba(34,197,94,0.04)',
    }],
  },
  tooltip: {
    shared: true,
    backgroundColor: '#111111',
    borderColor: 'transparent',
    borderRadius: 12,
    shadow: { color: 'rgba(0,0,0,0.2)', width: 8, opacity: 0.5 },
    style: { color: '#fff', fontSize: '12px' },
    pointFormat: '<span style="color:{series.color}">●</span> {series.name}: <b>{point.y}</b><br/>',
    headerFormat: '<span style="font-size:11px;color:#aaa">{point.key}</span><br/>',
  },
  plotOptions: {
    spline: {
      depth: 25,
      lineWidth: 3,
      states: { hover: { lineWidth: 4 } },
      marker: {
        enabled: true,
        radius: 4,
        fillColor: '#fff',
        lineColor: '${widget.accentColor}',
        lineWidth: 2,
        symbol: 'circle',
        states: { hover: { radius: 6, fillColor: '${widget.accentColor}' } },
      },
    }
  },
  series: [{
    name: '${widget.seriesName}',
    data: $yData,
    color: '${widget.accentColor}',
    zones: [{
      value: 70,
      color: '#EF4444',
    },{
      value: 80,
      color: '#F97316',
    },{
      color: '#22C55E',
    }],
    marker: {
      fillColor: '#fff',
      lineColor: '${widget.accentColor}',
      lineWidth: 2,
      radius: 5,
    },
  }$extraSeries]
});
</script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: widget.dataPoints.isEmpty
          ? const _EmptyChart()
          : WebViewWidget(controller: _controller),
    );
  }
}

// ─── Empty state placeholder ──────────────────────────────────────────────────
class _EmptyChart extends StatelessWidget {
  const _EmptyChart();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.show_chart_rounded, size: 36, color: Color(0xFFCCCCCC)),
        SizedBox(height: 8),
        Text('Chưa có dữ liệu phân tích',
            style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA))),
      ]),
    );
  }
}
