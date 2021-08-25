import 'package:fl_chart_app/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/editor/editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).accentTextTheme,
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const EditorPage(),
    );
  }
}
