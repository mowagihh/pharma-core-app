import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The points + level badge from the Home header in App.tsx.
class GamificationBadge extends StatelessWidget {
  final int points;
  final String level;
  const GamificationBadge(
      {super.key, required this.points, required this.level});

  List<Color> _levelColors(String level) {
    switch (level) {
      case 'diamond':
        return [const Color(0xFF22D3EE), const Color(0xFF2563EB)];
      case 'gold':
        return [const Color(0xFFFACC15), const Color(0xFFD97706)];
      case 'silver':
        return [const Color(0xFFCBD5E1), const Color(0xFF64748B)];
      case 'bronze':
        return [const Color(0xFFFB923C), const Color(0xFFEA580C)];
      default:
        return [const Color(0xFF94A3B8), const Color(0xFF64748B)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('نقاطك',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: context.muted)),
              Text('$points',
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1.0,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _levelColors(level),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: context.surface, shape: BoxShape.circle),
              child: Icon(Icons.workspace_premium_rounded,
                  size: 16, color: context.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
