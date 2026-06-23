import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/drug.dart';
import '../theme/app_theme.dart';

/// Faithful port of DrugCard.tsx — 28px rounded card, company + names,
/// EGP price, change badge, date pill, chevron. Adds a favorite toggle.
class DrugCard extends StatelessWidget {
  final Drug drug;
  final int index;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const DrugCard({
    super.key,
    required this.drug,
    required this.index,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  String _formatDate(DateTime? d) {
    if (d == null) return 'محدث الآن';
    return DateFormat('d MMM', 'ar').format(d);
  }

  @override
  Widget build(BuildContext context) {
    final pNew = drug.priceNew;
    final pOld = drug.priceOld;
    final changed = drug.hasPriceChange;
    final up = drug.isIncrease;

    final Color iconBg, iconBorder, iconColor;
    if (changed) {
      if (up) {
        iconBg = AppColors.increase.withOpacity(0.1);
        iconBorder = AppColors.increase.withOpacity(0.2);
        iconColor = AppColors.increase;
      } else {
        iconBg = AppColors.decrease.withOpacity(0.1);
        iconBorder = AppColors.decrease.withOpacity(0.2);
        iconColor = AppColors.decrease;
      }
    } else {
      iconBg = context.isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9);
      iconBorder = context.border;
      iconColor = context.muted;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: context.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(context.isDark ? 0.0 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              (drug.company ?? '').toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: context.muted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('#${index + 1}',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: context.muted.withOpacity(0.6))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        drug.nameEn,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: context.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        drug.nameAr.isEmpty ? '---' : drug.nameAr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: iconBorder),
                  ),
                  child: Icon(Icons.medication_rounded,
                      size: 24, color: iconColor),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            pNew?.toStringAsFixed(2) ?? '--',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: context.textColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text('EGP',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: context.muted)),
                        ],
                      ),
                      if (changed) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              pOld?.toStringAsFixed(2) ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.lineThrough,
                                color: context.muted.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: up
                                    ? AppColors.increase
                                    : AppColors.decrease,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      up
                                          ? Icons.north_east_rounded
                                          : Icons.south_east_rounded,
                                      size: 10,
                                      color: Colors.white),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${drug.changePercent.abs().toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onToggleFavorite();
                  },
                  icon: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFavorite ? const Color(0xFFF59E0B) : context.muted,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 11, color: context.muted),
                      const SizedBox(width: 6),
                      Text(_formatDate(drug.apiUpdatedAt),
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: context.muted)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.chevron_left_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
