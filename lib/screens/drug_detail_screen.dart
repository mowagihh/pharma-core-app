import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/drug.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

/// Improvement: a dedicated detail screen with an explicit old-vs-new
/// price comparison and change breakdown.
class DrugDetailScreen extends StatelessWidget {
  final Drug drug;
  const DrugDetailScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fav = state.isFavorite(drug.drugNo);
    final up = drug.isIncrease;
    final accent =
        drug.hasPriceChange ? (up ? AppColors.increase : AppColors.decrease) : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: context.textColor,
        title: const Text('تفاصيل الدواء',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AppState>().toggleFavorite(drug.drugNo),
            icon: Icon(
              fav ? Icons.star_rounded : Icons.star_outline_rounded,
              color: fav ? const Color(0xFFF59E0B) : context.muted,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: accent.withOpacity(0.2)),
              ),
              child: Icon(Icons.medication_rounded, size: 44, color: accent),
            ),
          ),
          const SizedBox(height: 20),
          Text(drug.nameEn,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: context.textColor)),
          const SizedBox(height: 4),
          Text(drug.nameAr.isEmpty ? '---' : drug.nameAr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.muted)),
          if ((drug.company ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: context.border),
                ),
                child: Text(drug.company!.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w900,
                        color: context.muted)),
              ),
            ),
          ],
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _priceCard(
                  context,
                  label: 'السعر الحالي',
                  value: drug.priceNew,
                  highlight: true,
                  accent: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _priceCard(
                  context,
                  label: 'السعر السابق',
                  value: drug.priceOld,
                  highlight: false,
                  accent: context.muted,
                ),
              ),
            ],
          ),
          if (drug.hasPriceChange) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      color: accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      up ? 'ارتفع السعر بنسبة' : 'انخفض السعر بنسبة',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: context.textColor),
                    ),
                  ),
                  Text('${drug.changePercent.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: accent)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          _infoRow(context, Icons.tag_rounded, 'رقم الدواء', drug.drugNo),
          _infoRow(
            context,
            Icons.calendar_today_rounded,
            'آخر تحديث',
            drug.apiUpdatedAt != null
                ? DateFormat('d MMMM yyyy', 'ar').format(drug.apiUpdatedAt!)
                : 'محدث الآن',
          ),
        ],
      ),
    );
  }

  Widget _priceCard(BuildContext context,
      {required String label,
      required double? value,
      required bool highlight,
      required Color accent}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: highlight ? accent.withOpacity(0.3) : context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: context.muted)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value?.toStringAsFixed(2) ?? '--',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: highlight ? accent : context.textColor)),
              const SizedBox(width: 4),
              Text('EGP',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: context.muted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.muted),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: context.muted)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: context.textColor)),
        ],
      ),
    );
  }
}
