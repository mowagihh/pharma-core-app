import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  final state = AppState();
  await state.bootstrap();
  runApp(
    ChangeNotifierProvider.value(value: state, child: const PharmaCoreApp()),
  );
}

class PharmaCoreApp extends StatelessWidget {
  const PharmaCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.watch<AppState>().darkMode;
    SystemChrome.setSystemUIOverlayStyle(
      dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
    return MaterialApp(
      title: 'Pharma Core',
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      // Force RTL to match the original direction:rtl layout.
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const Shell(),
    );
  }
}
