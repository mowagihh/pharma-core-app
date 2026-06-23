import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drug.dart';
import '../theme/app_theme.dart';

/// Port of TabFilter.tsx — segmented pill (الكل / تغييرات / المفضلة).
class TabFilter extends StatelessWidget {
  final TabMode current;
  final ValueChanged<TabMode> onChange;
  const TabFilter({super.key, required this.current, required this.onChange});

  static const _tabs = [
    (TabMode.all, 'الكل', Icons.grid_view_rounded),
    (TabMode.changed, 'تغييرات', Icons.trending_up_rounded),
    (TabMode.fav, 'المفضلة', Icons.star_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: _tabs.map((t) {
          final active = current == t.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChange(t.$1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary.withOpacity(context.isDark ? 0.2 : 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: active
                        ? AppColors.primary.withOpacity(0.25)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(t.$3,
                        size: 18,
                        color: active ? AppColors.primary : context.muted),
                    const SizedBox(width: 6),
                    Text(
                      t.$2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            active ? FontWeight.w900 : FontWeight.w700,
                        color: active ? AppColors.primary : context.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
