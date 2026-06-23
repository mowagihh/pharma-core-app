import 'package:flutter/material.dart';
import '../models/drug.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Central app state (replaces the React useState/useEffect cluster in App.tsx).
class AppState extends ChangeNotifier {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  final List<Drug> _allDrugs = [];
  bool _loading = true;
  bool _fetchingMore = false;
  bool _exhausted = false;
  String _search = '';
  TabMode _mode = TabMode.all;
  SortMode _sort = SortMode.none;
  bool _darkMode = false;
  Set<String> _favorites = {};

  // Gamification (mirrors the mocked header data in App.tsx).
  final int points = 1250;
  final String level = 'gold';

  bool get loading => _loading;
  bool get fetchingMore => _fetchingMore;
  bool get exhausted => _exhausted;
  String get search => _search;
  TabMode get mode => _mode;
  SortMode get sort => _sort;
  bool get darkMode => _darkMode;
  Set<String> get favorites => _favorites;
  int get totalLoaded => _allDrugs.length;

  Future<void> bootstrap() async {
    _darkMode = await _storage.loadDarkMode();
    _favorites = await _storage.loadFavorites();
    notifyListeners();
    await loadInitial();
  }

  Future<void> loadInitial() async {
    _loading = true;
    _exhausted = false;
    notifyListeners();
    final results = await _api.fetchBatch(0);
    _allDrugs
      ..clear()
      ..addAll(_dedupe(results));
    _loading = false;
    if (results.isNotEmpty) _api.saveCache(_allDrugs);
    notifyListeners();
  }

  Future<void> refresh() => loadInitial();

  Future<void> loadMore() async {
    if (_fetchingMore || _exhausted || _search.isNotEmpty) return;
    _fetchingMore = true;
    notifyListeners();
    final results = await _api.fetchBatch(_allDrugs.length);
    if (results.isEmpty) {
      _exhausted = true;
    } else {
      _allDrugs
        ..clear()
        ..addAll(_dedupe([..._allDrugs, ...results]));
    }
    _fetchingMore = false;
    notifyListeners();
  }

  List<Drug> _dedupe(List<Drug> list) {
    final map = <String, Drug>{};
    for (final d in list) {
      map[d.drugNo] = d;
    }
    return map.values.toList();
  }

  /// Filtered + sorted list shown on Home.
  List<Drug> get filteredDrugs {
    Iterable<Drug> list = _allDrugs;

    if (_mode == TabMode.changed) {
      list = list.where((d) => d.hasPriceChange);
    } else if (_mode == TabMode.fav) {
      list = list.where((d) => _favorites.contains(d.drugNo));
    }

    if (_search.isNotEmpty) {
      final s = _search.toLowerCase();
      list = list.where((d) =>
          d.nameEn.toLowerCase().contains(s) ||
          d.nameAr.contains(_search) ||
          d.drugNo.contains(_search));
    }

    final result = list.toList();
    switch (_sort) {
      case SortMode.priceAsc:
        result.sort((a, b) => (a.priceNew ?? 0).compareTo(b.priceNew ?? 0));
        break;
      case SortMode.priceDesc:
        result.sort((a, b) => (b.priceNew ?? 0).compareTo(a.priceNew ?? 0));
        break;
      case SortMode.changeDesc:
        result.sort((a, b) => b.changePercent.abs().compareTo(a.changePercent.abs()));
        break;
      case SortMode.nameAsc:
        result.sort((a, b) => a.nameEn.compareTo(b.nameEn));
        break;
      case SortMode.none:
        break;
    }
    return result;
  }

  List<Drug> get allDrugs => List.unmodifiable(_allDrugs);

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setMode(TabMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void setSort(SortMode sort) {
    _sort = sort;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    _storage.saveDarkMode(_darkMode);
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    _favorites = {..._favorites};
    _storage.saveFavorites(_favorites);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites = {};
    _storage.saveFavorites(_favorites);
    notifyListeners();
  }
}
