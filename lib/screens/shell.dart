import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'community_screen.dart';
import 'inventory_screen.dart';
import 'settings_screen.dart';

/// Hosts the four primary tabs behind the floating bottom nav.
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    CommunityScreen(),
    InventoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: FloatingBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
