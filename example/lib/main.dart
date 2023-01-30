import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/router/app_router.dart';

import 'package:fl_chart_app/util/web/non_web_url_strategy.dart'
    if (dart.library.html) 'package:fl_chart_app/util/web/web_url_strategy.dart';

void main() {
  configureWebUrl();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppTexts.appName,
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
      routerConfig: appRouterConfig,
    );
  }
}
