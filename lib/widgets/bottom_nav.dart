import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Floating pill bottom nav — port of Navigation.tsx.
class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const FloatingBottomNav(
      {super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_rounded, 'الرئيسية'),
    (Icons.groups_rounded, 'المجتمع'),
    (Icons.inventory_2_rounded, 'المخزون'),
    (Icons.more_horiz_rounded, 'المزيد'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: context.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(context.isDark ? 0.5 : 0.12),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (i) {
              final active = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (active)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle),
                          )
                        else
                          const SizedBox(height: 8),
                        AnimatedScale(
                          scale: active ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            _items[i].$1,
                            size: 22,
                            color: active ? AppColors.primary : context.muted,
                          ),
                        ),
                        if (active) ...[
                          const SizedBox(height: 2),
                          Text(
                            _items[i].$2,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
