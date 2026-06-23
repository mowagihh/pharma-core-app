import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/drug.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'analytics_screen.dart';

/// Inventory / shortages view — mirrors InventoryView.tsx.
/// Improvement: derives a simple stock + shortage simulation from live data
/// and surfaces quick stats and an analytics entry point.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drugs = context.watch<AppState>().allDrugs;
    final changed = drugs.where((d) => d.hasPriceChange).toList();
    // Treat steep increases as "at risk of shortage" for the demo.
    final shortages = drugs
        .where((d) => d.isIncrease && d.changePercent.abs() > 10)
        .take(20)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 140),
      children: [
        Row(
          children: [
            const Icon(Icons.inventory_2_rounded,
                color: AppColors.primary, size: 28),
            const SizedBox(width: 10),
            Text('المخزون',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: context.textColor)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: _stat(context, 'إجمالي الأصناف', '${drugs.length}',
                    Icons.medication_rounded, AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(
                child: _stat(context, 'تغيرت أسعارها', '${changed.length}',
                    Icons.trending_up_rounded, const Color(0xFFF59E0B))),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.bar_chart_rounded, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('تحليلات المخزون والأسعار',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16)),
                ),
                const Icon(Icons.chevron_left_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Color(0xFFF59E0B), size: 18),
            const SizedBox(width: 8),
            Text('أصناف تحت المراقبة',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: context.textColor)),
          ],
        ),
        const SizedBox(height: 12),
        if (shortages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      size: 48, color: AppColors.decrease),
                  const SizedBox(height: 12),
                  Text('لا توجد أصناف حرجة حالياً',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: context.muted)),
                ],
              ),
            ),
          )
        else
          ...shortages.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ShortageRow(drug: e.value)
                    .animate()
                    .fadeIn(delay: (e.key * 50).ms),
              )),
      ],
    );
  }

  Widget _stat(BuildContext context, String label, String value, IconData icon,
      Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: context.textColor)),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.muted)),
        ],
      ),
    );
  }
}

class _ShortageRow extends StatelessWidget {
  final Drug drug;
  const _ShortageRow({required this.drug});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.increase.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.priority_high_rounded,
                color: AppColors.increase),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drug.nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: context.textColor)),
                Text(drug.nameAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.muted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.increase,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('+${drug.changePercent.abs().toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
