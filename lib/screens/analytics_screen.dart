import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/drug.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

/// Improvement: native charts (fl_chart) port of StockAnalytics.tsx.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drugs = context.watch<AppState>().allDrugs;
    final low = drugs.where((d) => (d.priceNew ?? 0) < 50).length;
    final mid = drugs
        .where((d) => (d.priceNew ?? 0) >= 50 && (d.priceNew ?? 0) <= 200)
        .length;
    final high = drugs.where((d) => (d.priceNew ?? 0) > 200).length;

    final gainers = [...drugs]
        .where((d) => d.hasPriceChange && d.isIncrease)
        .toList()
      ..sort((a, b) => b.changePercent.compareTo(a.changePercent));
    final topGainers = gainers.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: context.textColor,
        title: const Text('التحليلات',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _section(context, 'توزيع نطاقات الأسعار'),
          const SizedBox(height: 16),
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.border),
            ),
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 50,
                sections: [
                  _slice(low.toDouble(), AppColors.decrease, 'أقل من 50'),
                  _slice(mid.toDouble(), AppColors.primary, '50-200'),
                  _slice(high.toDouble(), const Color(0xFFF59E0B), 'أعلى من 200'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legend(context, AppColors.decrease, 'أقل من 50', low),
              _legend(context, AppColors.primary, '50-200', mid),
              _legend(context, const Color(0xFFF59E0B), '+200', high),
            ],
          ),
          const SizedBox(height: 32),
          _section(context, 'الأعلى ارتفاعاً في السعر'),
          const SizedBox(height: 16),
          if (topGainers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text('لا توجد بيانات كافية',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: context.muted)),
              ),
            )
          else
            Container(
              height: 240,
              padding: const EdgeInsets.fromLTRB(8, 24, 16, 8),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.border),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= topGainers.length) {
                            return const SizedBox();
                          }
                          final name = topGainers[i].nameEn;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              name.length > 6 ? name.substring(0, 6) : name,
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: context.muted),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: topGainers.asMap().entries.map((e) {
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: e.value.changePercent.abs(),
                        width: 22,
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PieChartSectionData _slice(double value, Color color, String title) {
    return PieChartSectionData(
      value: value <= 0 ? 0.001 : value,
      color: color,
      title: value <= 0 ? '' : value.toInt().toString(),
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
    );
  }

  Widget _legend(BuildContext context, Color color, String label, int count) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: context.textColor)),
          ],
        ),
        const SizedBox(height: 2),
        Text('$count صنف',
            style: TextStyle(fontSize: 10, color: context.muted)),
      ],
    );
  }

  Widget _section(BuildContext context, String title) => Text(title,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: context.textColor));
}
