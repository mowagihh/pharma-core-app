import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'analytics_screen.dart';

/// "المزيد" / Settings — mirrors SettingsView.tsx.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 140),
      children: [
        Row(
          children: [
            const Icon(Icons.settings_rounded,
                color: AppColors.primary, size: 28),
            const SizedBox(width: 10),
            Text('المزيد',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: context.textColor)),
          ],
        ),
        const SizedBox(height: 24),
        // Profile card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary]),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مستخدم تجريبي',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                    Text('${state.points} نقطة · المستوى الذهبي',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _group(context, 'التفضيلات', [
          _SwitchTile(
            icon: Icons.dark_mode_rounded,
            label: 'الوضع الليلي',
            value: state.darkMode,
            onChanged: (_) => context.read<AppState>().toggleDarkMode(),
          ),
        ]),
        const SizedBox(height: 16),
        _group(context, 'الأدوات', [
          _NavTile(
            icon: Icons.bar_chart_rounded,
            label: 'التحليلات',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen())),
          ),
          _NavTile(
            icon: Icons.star_outline_rounded,
            label: 'مسح المفضلة',
            onTap: () {
              context.read<AppState>().clearFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم مسح المفضلة')),
              );
            },
          ),
          _NavTile(
            icon: Icons.refresh_rounded,
            label: 'تحديث البيانات',
            onTap: () {
              context.read<AppState>().refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تحديث البيانات...')),
              );
            },
          ),
        ]),
        const SizedBox(height: 16),
        _group(context, 'حول التطبيق', [
          _NavTile(
            icon: Icons.code_rounded,
            label: 'المشروع على GitHub',
            onTap: () => launchUrl(
              Uri.parse('https://github.com/joker7x/PharmacoreV1'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          _NavTile(
            icon: Icons.info_outline_rounded,
            label: 'الإصدار 4.0.0',
            onTap: () {},
          ),
        ]),
        const SizedBox(height: 24),
        Center(
          child: Text('PHARMA CORE · Premium v4.0',
              style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w900,
                  color: context.muted)),
        ),
      ],
    );
  }

  Widget _group(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 10),
          child: Text(title,
              style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w900,
                  color: context.muted)),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.w800, color: context.textColor)),
      trailing: Switch(
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.w800, color: context.textColor)),
      trailing: Icon(Icons.chevron_left_rounded, color: context.muted),
    );
  }
}
