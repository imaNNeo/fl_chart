import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bar_chart/bar_chart_page.dart';
import 'bar_chart/bar_chart_page2.dart';
import 'line_chart/line_chart_page.dart';
import 'line_chart/line_chart_page2.dart';
import 'line_chart/line_chart_page3.dart';
import 'line_chart/line_chart_page4.dart';
import 'pie_chart/pie_chart_page.dart';
import 'scatter_chart/scatter_chart_page.dart';
import 'utils/AppColors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
      showPerformanceOverlay: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        primaryColor: const Color(0xff262545),
        primaryColorDark: const Color(0xff201f39),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'fl_chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double menuWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, BoxConstraints constrains) {
          if (constrains.maxWidth > 800) {
            return Stack(
              children: <Widget>[
                Container(
                  color: menuBgColor,
                ),
                SizedBox(
                  width: menuWidth,
                  height: double.infinity,
                  child: LeftMenu(),
                ),
                Container(
                  margin: EdgeInsets.only(left: menuWidth),
                  decoration: BoxDecoration(
                    color: pageBgColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32),
                    ),
                  ),
                )
              ],
            );
          }

          return SafeArea(
            child: Stack(
              children: <Widget>[
                PageView(
                  children: <Widget>[
                    LineChartPage(),
                    BarChartPage(),
                    BarChartPage2(),
                    PieChartPage(),
                    LineChartPage2(),
                    LineChartPage3(),
                    LineChartPage4(),
                    ScatterChartPage(),
                  ],
                ),
                Center(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Text(
                      '${constrains.maxWidth} x ${constrains.maxHeight}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class LeftMenu extends StatefulWidget {
  static const double paddingLeft = 24;

  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  int selectedPos = 0;

  List<String> charts = [
    'Line Chart',
    'Bar Chart',
    'Pie Chart',
    'Scatter Chart',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(
          height: 48,
        ),
        Center(
          child: FLChartLogo(),
        ),
        const SizedBox(
          height: 32,
        ),
        ...charts.asMap().entries.map(
              (indexTitle) => MenuRow(
                text: indexTitle.value,
                isSelected: indexTitle.key == selectedPos,
                onTap: () {
                  setState(() {
                    selectedPos = indexTitle.key;
                  });
                },
              ),
            ),
      ],
    );
  }
}

class FLChartLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Image.asset(
          'logo_indicator.png',
          height: 52,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          'FL Chart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ],
    );
  }
}

class MenuRow extends StatelessWidget {
  static const double verticalSpace = 40;

  final String text;
  final bool isSelected;
  final Function onTap;

  const MenuRow({Key key, this.text, this.isSelected = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(
              left: LeftMenu.paddingLeft,
              top: verticalSpace / 2,
              bottom: verticalSpace / 2,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(isSelected ? 1.0 : 0.2),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
