import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: AppColors.mainTextColor3,
              ),
        ),
        scaffoldBackgroundColor: AppColors.pageBackground,
      ),
      home: const HomePage(),
    );
  }
}
