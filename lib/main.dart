import 'package:expense_manager/ui/dashboardScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('vi', 'VN'), // Hỗ trợ Tiếng Việt
          Locale('en', 'US'), // Hỗ trợ Tiếng Anh (mặc định)
        ],
        locale: Locale('vi', 'VN'),
        home: DashboardScreen());
  }
}
