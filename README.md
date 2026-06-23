# Pharma Core — Flutter Mobile App

A faithful Flutter rebuild of the [PharmacoreV1](https://github.com/joker7x/PharmacoreV1)
React/TypeScript web app — *"The professional standard for drug inventory and price tracking."*

This is a native, cross-platform (Android + iOS) mobile app that preserves the original
design language (RTL Arabic, blue brand identity, floating bottom navigation, the signature
DrugCard, gamification badge, dark mode) while adding a set of mobile-first improvements.

## Same Design, Preserved
- **RTL Arabic** layout with IBM Plex Sans Arabic typography (via google_fonts).
- **Brand palette**: primary `#2563eb`, secondary `#4f46e5`, slate surfaces, soft shadows.
- **Floating pill bottom navigation**: الرئيسية / المجتمع / المخزون / المزيد.
- **Home**: PHARMA CORE header + gamification points badge, search bar, tab filter
  (الكل / تغييرات / المفضلة), and the drug list.
- **DrugCard**: company, EN/AR names, EGP price, price-change % badge (red up / green down),
  update date, Pill icon, chevron — matching the 28px rounded card style.
- **Dark mode** with smooth theme transitions.
- Live data from the same **Medhome API** (`lastpricesForFlutter` POST endpoint).

## Improvements Added (mobile-first)
1. **Working Favorites** — original had favorites stubbed out; now fully persistent
   (shared_preferences) with the المفضلة tab functional.
2. **Offline cache** — last fetched drug batch is cached locally and shown instantly on
   next launch, even with no connection.
3. **Pull-to-refresh** + **infinite scroll pagination** on the drug list.
4. **Barcode / QR scanner** to search a drug by scanning its package (mobile_scanner) —
   replaces the web html5-qrcode flow with a native camera experience.
5. **Sort & filter controls** — sort by price, by largest price change, alphabetically.
6. **Drug detail screen** with a clear old-vs-new price comparison and change breakdown.
7. **Analytics** screen with native charts (fl_chart): price-range distribution and
   top gainers.
8. **Haptic feedback** on key interactions and **staggered entrance animations**
   (flutter_animate).
9. **Skeleton/shimmer loaders** for a premium perceived-performance feel.
10. **Graceful fallback data** so the app is fully demoable offline.

## Project Structure
```
lib/
  main.dart                  app entry, theme + provider wiring
  theme/app_theme.dart       light/dark themes, brand colors
  models/                    drug.dart, community.dart
  services/
    api_service.dart         Medhome API client + offline cache
    storage_service.dart     favorites + prefs persistence
  providers/app_state.dart   central state (drugs, search, tab, favorites, theme)
  screens/                   home, drug_detail, community, inventory,
                             settings, analytics, scanner
  widgets/                   drug_card, tab_filter, bottom_nav, search_field,
                             gamification_badge, skeleton_card
```

## Run
```bash
flutter pub get
flutter run
```
Requires Flutter 3.3+ (Dart 3). Grant camera permission for the barcode scanner.
