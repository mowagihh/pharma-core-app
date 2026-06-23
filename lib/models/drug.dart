/// Core drug model — mirrors the `Drug` interface in the original types.ts.
class Drug {
  final String drugNo;
  final String nameEn;
  final String nameAr;
  final String? company;
  final double? priceNew;
  final double? priceOld;
  final int? packSize;
  final String? dosageForm;
  final DateTime? apiUpdatedAt;

  const Drug({
    required this.drugNo,
    required this.nameEn,
    required this.nameAr,
    this.company,
    this.priceNew,
    this.priceOld,
    this.packSize,
    this.dosageForm,
    this.apiUpdatedAt,
  });

  bool get hasPriceChange =>
      priceNew != null && priceOld != null && priceNew != priceOld;

  bool get isIncrease => hasPriceChange && priceNew! > priceOld!;

  /// Percentage change magnitude (absolute value).
  double get changePercent {
    if (priceNew == null || priceOld == null || priceOld == 0) return 0;
    return ((priceNew! - priceOld!) / priceOld!) * 100;
  }

  /// Maps the external Medhome API shape -> Drug (same logic as api.ts).
  factory Drug.fromExternal(Map<String, dynamic> item) {
    double? parsePrice(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return double.tryParse(s);
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      final raw = int.tryParse(v.toString());
      if (raw == null) return null;
      final ms = raw < 10000000000 ? raw * 1000 : raw;
      return DateTime.fromMillisecondsSinceEpoch(ms);
    }

    final name = (item['name'] ?? '').toString();
    return Drug(
      drugNo: (item['id']?.toString().isNotEmpty ?? false)
          ? item['id'].toString()
          : 'drug-${name.replaceAll(RegExp(r"\s+"), "-")}-${DateTime.now().microsecondsSinceEpoch}',
      nameEn: name.isEmpty ? 'Unknown Product' : name,
      nameAr: (item['arabic'] ?? '').toString(),
      company: (item['company']?.toString().isNotEmpty ?? false)
          ? item['company'].toString()
          : null,
      priceNew: parsePrice(item['price']),
      priceOld: parsePrice(item['oldprice']),
      apiUpdatedAt: parseDate(item['Date_updated']),
    );
  }

  Map<String, dynamic> toJson() => {
        'drug_no': drugNo,
        'name_en': nameEn,
        'name_ar': nameAr,
        'company': company,
        'price_new': priceNew,
        'price_old': priceOld,
        'pack_size': packSize,
        'dosage_form': dosageForm,
        'api_updated_at': apiUpdatedAt?.toIso8601String(),
      };

  factory Drug.fromJson(Map<String, dynamic> j) => Drug(
        drugNo: j['drug_no'] ?? '',
        nameEn: j['name_en'] ?? '',
        nameAr: j['name_ar'] ?? '',
        company: j['company'],
        priceNew: (j['price_new'] as num?)?.toDouble(),
        priceOld: (j['price_old'] as num?)?.toDouble(),
        packSize: j['pack_size'],
        dosageForm: j['dosage_form'],
        apiUpdatedAt: j['api_updated_at'] != null
            ? DateTime.tryParse(j['api_updated_at'])
            : null,
      );
}

enum TabMode { all, changed, fav }

enum SortMode { none, priceAsc, priceDesc, changeDesc, nameAsc }
