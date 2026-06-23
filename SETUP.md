# Setup & Run

This repo contains the Flutter source (`lib/`), `pubspec.yaml`, and bundled
assets. Generate the native platform folders once, then run.

```bash
# 1. From the project root, generate android/ ios/ etc. (keeps lib/ + pubspec)
flutter create .

# 2. Fetch dependencies
flutter pub get

# 3. Run on a device/emulator
flutter run
```

## Required permissions (for the barcode scanner)

### Android — `android/app/src/main/AndroidManifest.xml`
Add inside `<manifest>` (above `<application>`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS — `ios/Runner/Info.plist`
Add:
```xml
<key>NSCameraUsageDescription</key>
<string>تُستخدم الكاميرا لمسح باركود الأدوية.</string>
```

## Notes
- Minimum: Flutter 3.3+ / Dart 3.
- The app forces RTL and uses IBM Plex Sans Arabic via `google_fonts`
  (downloaded at first run; needs internet once, then cached).
- If the Medhome API is unreachable, the app shows bundled sample data and any
  previously cached batch, so it always runs.
