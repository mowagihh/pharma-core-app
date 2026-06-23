import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/drug.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/drug_card.dart';
import '../widgets/tab_filter.dart';
import '../widgets/gamification_badge.dart';
import '../widgets/skeleton_card.dart';
import 'drug_detail_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 400) {
        context.read<AppState>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openScanner() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
    if (code != null && mounted) {
      _searchController.text = code;
      context.read<AppState>().setSearch(code);
    }
  }

  void _openSortSheet() {
    final state = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: context.muted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 8),
            ...[
              (SortMode.none, 'الافتراضي', Icons.list_rounded),
              (SortMode.changeDesc, 'الأكثر تغيراً', Icons.trending_up_rounded),
              (SortMode.priceDesc, 'الأعلى سعراً', Icons.arrow_downward_rounded),
              (SortMode.priceAsc, 'الأقل سعراً', Icons.arrow_upward_rounded),
              (SortMode.nameAsc, 'أبجدياً', Icons.sort_by_alpha_rounded),
            ].map((o) => ListTile(
                  leading: Icon(o.$3, color: AppColors.primary),
                  title: Text(o.$2,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  trailing: state.sort == o.$1
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    state.setSort(o.$1);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final drugs = state.filteredDrugs;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<AppState>().refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _header(state)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
            sliver: _body(state, drugs),
          ),
        ],
      ),
    );
  }

  Widget _header(AppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 64, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: context.textColor,
                        ),
                        children: const [
                          TextSpan(text: 'PHARMA '),
                          TextSpan(
                              text: 'CORE',
                              style: TextStyle(color: AppColors.primary)),
                        ],
                      ),
                    ),
                    Text('PREMIUM V4.0',
                        style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                            color: context.muted)),
                  ],
                ),
              ),
              GamificationBadge(points: state.points, level: state.level),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: context.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: context.read<AppState>().setSearch,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: context.textColor),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن دواء، شركة، أو باركود...',
                      hintStyle: TextStyle(
                          color: context.muted,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                      prefixIcon:
                          Icon(Icons.search_rounded, color: context.muted),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _circleBtn(Icons.qr_code_scanner_rounded, _openScanner),
              const SizedBox(width: 8),
              _circleBtn(Icons.tune_rounded, _openSortSheet),
            ],
          ),
          const SizedBox(height: 24),
          TabFilter(
            current: state.mode,
            onChange: context.read<AppState>().setMode,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.grid_view_rounded,
                      size: 14, color: context.muted),
                  const SizedBox(width: 6),
                  Text('قائمة الأدوية',
                      style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                          color: context.muted)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text('${context.watch<AppState>().filteredDrugs.length} صنف متاح',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.border),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }

  Widget _body(AppState state, List<Drug> drugs) {
    if (state.loading && drugs.isEmpty) {
      return SliverList.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => const SkeletonCard(),
      );
    }
    if (drugs.isEmpty) {
      return SliverToBoxAdapter(child: _empty(state));
    }
    return SliverList.separated(
      itemCount: drugs.length + (state.fetchingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        if (i >= drugs.length) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }
        final d = drugs[i];
        return DrugCard(
          drug: d,
          index: i,
          isFavorite: state.isFavorite(d.drugNo),
          onToggleFavorite: () =>
              context.read<AppState>().toggleFavorite(d.drugNo),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DrugDetailScreen(drug: d)),
          ),
        ).animate().fadeIn(duration: 350.ms, delay: (i * 40).clamp(0, 240).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _empty(AppState state) {
    final fav = state.mode == TabMode.fav;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(fav ? Icons.star_outline_rounded : Icons.search_off_rounded,
              size: 56, color: context.muted),
          const SizedBox(height: 16),
          Text(
            fav ? 'لا توجد أدوية في المفضلة بعد' : 'لا توجد نتائج',
            style: TextStyle(
                fontWeight: FontWeight.w900, color: context.textColor),
          ),
          const SizedBox(height: 6),
          Text(
            fav ? 'اضغط على النجمة لإضافة دواء' : 'جرّب كلمة بحث مختلفة',
            style: TextStyle(color: context.muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
