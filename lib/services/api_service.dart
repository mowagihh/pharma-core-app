import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/drug.dart';

/// Talks to the same Medhome feed used by the original app, with an
/// offline cache layer (improvement) so the list survives no-connectivity.
class ApiService {
  static const String medhomeApiUrl =
      'https://dwaprices.com/api_dr88g/serverz.php';
  static const String _cacheKey = 'cached_drugs_v1';

  /// Fetches a batch of drugs starting at [offset].
  /// POST body: `lastpricesForFlutter=<offset>` (same contract as api.ts).
  Future<List<Drug>> fetchBatch(int offset) async {
    try {
      final res = await http
          .post(
            Uri.parse(medhomeApiUrl),
            headers: {
              'Content-Type':
                  'application/x-www-form-urlencoded; charset=utf-8',
            },
            body: 'lastpricesForFlutter=$offset',
          )
          .timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body);
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => Drug.fromExternal(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (_) {
      // On the first page, fall back to bundled sample data so the app is
      // always demoable (improvement).
      if (offset == 0) {
        final cached = await loadCache();
        if (cached.isNotEmpty) return cached;
        return _loadSample();
      }
      return [];
    }
  }

  Future<void> saveCache(List<Drug> drugs) async {
    final prefs = await SharedPreferences.getInstance();
    final slice = drugs.take(200).map((d) => d.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(slice));
  }

  Future<List<Drug>> loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => Drug.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Drug>> _loadSample() async {
    try {
      final raw = await rootBundle.loadString('assets/data/sample_drugs.json');
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => Drug.fromExternal(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
