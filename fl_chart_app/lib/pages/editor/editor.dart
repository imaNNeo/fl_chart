import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/pages/widgets/treeview.dart';
import 'package:fl_chart_app/resources/app_colors.dart';
import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:flutter/material.dart';

import 'nodes/scatter/scatter_nodes.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  ScatterChartData data = ScatterChartData(
    minX: 0,
    minY: 0,
    maxY: 10,
    maxX: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: AppDimens.editorPanelWidth,
            color: Colors.white10,
            child: TreeViewer<ScatterChartData>(
              root: createScatterChartDataNode(data, (newScatterChartData) {
                setState(() {
                  data = newScatterChartData;
                });
              }),
              width: AppDimens.editorPanelWidth,
              iconColor: AppColors.editorItemsColor,
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ScatterChart(data),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
