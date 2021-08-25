import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/pages/editor/nodes/base/base_nodes.dart';
import 'package:fl_chart_app/pages/editor/nodes/primitive/primitive_node_widgets.dart';
import 'package:fl_chart_app/pages/editor/nodes/primitive/primitive_nodes.dart';
import 'package:fl_chart_app/pages/widgets/treeview.dart';
import 'package:flutter/material.dart';

import '../../dialogs/editor_dialogs.dart';
import 'scatter_node_widgets.dart';

TreeNode<ScatterChartData> createScatterChartDataNode(
  ScatterChartData data,
  SuggestToChangeMe<ScatterChartData> suggestToChangeMe,
) {
  final scatterChartDataNode = TreeNode<ScatterChartData>(
    nodeId: 'ScatterChartData',
    widget: TextNodeWidget('ScatterChartData'),
    parentNode: null,
    data: data,
    onRightClick: (context, node, depth, event) async {
      showContextMenu(context, event.position, [
        ContextMenuOption('Reset data', () {
          suggestToChangeMe(ScatterChartData(minX: 0, minY: 0, maxY: 10, maxX: 10));
        }),
        ContextMenuOption('Export to JSON', () {}),
      ]);
    },
  );

  return scatterChartDataNode.copyWith(children: [
    createScatterSpotsNode(scatterChartDataNode, 'scatterSpots', data.scatterSpots, (newData) {
      suggestToChangeMe(data.copyWith(scatterSpots: newData));
    }),
    createFlTitlesDataNode(scatterChartDataNode, 'titlesData', data.titlesData, (newData) {
      suggestToChangeMe(data.copyWith(titlesData: newData));
    }),
    createScatterTouchDataNode(scatterChartDataNode, 'scatterTouchData', data.scatterTouchData, (newData) {
      suggestToChangeMe(data.copyWith(scatterTouchData: newData));
    }),
    createIntListNode(scatterChartDataNode, 'showingTooltipIndicators', data.showingTooltipIndicators, (newData) {
      suggestToChangeMe(data.copyWith(showingTooltipIndicators: newData));
    }),
    createFlGridDataNode(scatterChartDataNode, 'gridData', data.gridData, (newData) {
      suggestToChangeMe(data.copyWith(gridData: newData));
    }),
    createFlBorderDataNode(scatterChartDataNode, 'borderData', data.borderData, (newData) {
      suggestToChangeMe(data.copyWith(borderData: newData));
    }),
    createFlAxisTitleDataNode(scatterChartDataNode, 'axisTitleData', data.axisTitleData, (newData) {
      suggestToChangeMe(data.copyWith(axisTitleData: newData));
    }),
    createDoubleNode(scatterChartDataNode, 'minX', data.minX, (newData) {
      suggestToChangeMe(data.copyWith(minX: newData));
    }),
    createDoubleNode(scatterChartDataNode, 'maxX', data.maxX, (newData) {
      suggestToChangeMe(data.copyWith(maxX: newData));
    }),
    createDoubleNode(scatterChartDataNode, 'minY', data.minY, (newData) {
      suggestToChangeMe(data.copyWith(minY: newData));
    }),
    createDoubleNode(scatterChartDataNode, 'maxY', data.maxY, (newData) {
      suggestToChangeMe(data.copyWith(maxY: newData));
    }),
    createFlClipDataNode(scatterChartDataNode, 'clipData', data.clipData, (newData) {
      suggestToChangeMe(data.copyWith(clipData: newData));
    }),
    createColorNode(scatterChartDataNode, 'backgroundColor', data.backgroundColor, (newData) {
      suggestToChangeMe(data.copyWith(backgroundColor: newData));
    })
  ]);
}

TreeNode<List<ScatterSpot>> createScatterSpotsNode(
  TreeNode parent,
  String name,
  List<ScatterSpot> data,
  SuggestToChangeMe<List<ScatterSpot>> suggestToChangeMe,
) {
  final scatterSpotsNode = TreeNode<List<ScatterSpot>>(
    nodeId: name,
    widget: TextNodeWidget(name),
    data: data,
    parentNode: parent,
  );

  final childNOdes = data.asMap().entries.map((entry) {
    final index = entry.key;
    final spot = entry.value;
    return createScatterSpotNode(scatterSpotsNode, 'scatterSpot${index}', spot, (newScatterSpot) {
      final newData = List.of(data);
      newData[index] = newScatterSpot;
      suggestToChangeMe(newData);
    });
  }).toList();
  return scatterSpotsNode.copyWith(
    children: childNOdes +
        [
          createAddNode<ScatterSpot>(scatterSpotsNode, 'Add ScatterSpot', (context, node, depth) async {
            final scatterChartData = parent.findRootNode!.data! as ScatterChartData;
            final newX =
            (scatterChartData.minX + Random().nextDouble() * scatterChartData.horizontalDiff).toInt().toDouble();
            final newY =
            (scatterChartData.minY + Random().nextDouble() * scatterChartData.verticalDiff).toInt().toDouble();
            final radius = ((Random().nextDouble() * 8) + 4).toInt().toDouble();
            var randomSpot = ScatterSpot(newX, newY, radius: radius);

            final newList = data + [randomSpot];
            suggestToChangeMe(newList);

            final newSpot = await showScatterSpotDialog(context, randomSpot, onHotChange: (newSpot) {
              newList[newList.length - 1] = newSpot;
              suggestToChangeMe(newList);
            });

            if (newSpot != null) {
              newList[newList.length - 1] = newSpot;
              suggestToChangeMe(newList);
            } else {
              newList.removeLast();
              suggestToChangeMe(newList);
            }
          })
        ],
  );
}

TreeNode<ScatterTouchData> createScatterTouchDataNode(
    TreeNode parent, String name, ScatterTouchData data, SuggestToChangeMe<ScatterTouchData> suggestToChangeMe) {
  final scatterTouchData = TreeNode(
    nodeId: name,
    widget: TextNodeWidget(name),
    data: data,
    parentNode: parent,
  );

  return scatterTouchData.copyWith(children: [
    createBooleanNode(scatterTouchData, 'enabled', data.enabled, (newData) {
      suggestToChangeMe(data.copyWith(enabled: newData));
    }),
    createBaseTouchCallbackNode<ScatterTouchResponse>(scatterTouchData, 'touchCallback', data.touchCallback, (newData) {
      suggestToChangeMe(data.copyWith(touchCallback: newData));
    }),
    createMouseCursorResolverNode<ScatterTouchResponse>(
        scatterTouchData, 'mouseCursorResolver', data.mouseCursorResolver, (newData) {
      suggestToChangeMe(data.copyWith(mouseCursorResolver: newData));
    }),
    createScatterTouchTooltipDataNode(scatterTouchData, 'touchTooltipData', data.touchTooltipData, (newData) {
      suggestToChangeMe(data.copyWith(touchTooltipData: newData));
    }),
    createDoubleNode(scatterTouchData, 'touchSpotThreshold', data.touchSpotThreshold, (newData) {
      suggestToChangeMe(data.copyWith(touchSpotThreshold: newData));
    }),
    createBooleanNode(scatterTouchData, 'handleBuiltInTouches', data.handleBuiltInTouches, (newData) {
      suggestToChangeMe(data.copyWith(handleBuiltInTouches: newData));
    }),
  ]);
}

TreeNode<ScatterSpot> createScatterSpotNode(
  TreeNode parent,
  String name,
  ScatterSpot data,
  SuggestToChangeMe<ScatterSpot> suggestToChangeMe,
) {
  return TreeNode(
    nodeId: name,
    widget: ScatterSpotNodeWidget(data),
    parentNode: parent,
    data: data,
    onClick: (context, node, depth) async {
      final newSpot = await showScatterSpotDialog(context, data, onHotChange: (newValue) {
        suggestToChangeMe(newValue);
      });
      if (newSpot == null) {
        suggestToChangeMe(data);
      } else {
        suggestToChangeMe(newSpot);
      }
    },
  );
}

TreeNode<GetScatterTooltipItems> createGetScatterTooltipItemsNode(
  TreeNode parent,
  String name,
  GetScatterTooltipItems data,
  SuggestToChangeMe<GetScatterTooltipItems> suggestToChangeMe,
) {
  return TreeNode<GetScatterTooltipItems>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
}

TreeNode<ScatterTouchTooltipData> createScatterTouchTooltipDataNode(
  TreeNode parent,
  String name,
  ScatterTouchTooltipData data,
  SuggestToChangeMe<ScatterTouchTooltipData> suggestToChangeMe,
) {
  final node = TreeNode<ScatterTouchTooltipData>(
    nodeId: name,
    widget: TextNodeWidget(name),
    data: data,
    parentNode: parent,
  );

  return node.copyWith(children: [
    createColorNode(node, 'tooltipBgColor', data.tooltipBgColor, (newData) {
      suggestToChangeMe(data.copyWith(tooltipBgColor: newData));
    }),
    createDoubleNode(node, 'tooltipRoundedRadius', data.tooltipRoundedRadius, (newData) {
      suggestToChangeMe(data.copyWith(tooltipRoundedRadius: newData));
    }),
    createEdgeInsetsNode(node, 'tooltipPadding', data.tooltipPadding, (newData) {
      suggestToChangeMe(data.copyWith(tooltipPadding: newData));
    }),
    createDoubleNode(node, 'maxContentWidth', data.maxContentWidth, (newData) {
      suggestToChangeMe(data.copyWith(maxContentWidth: newData));
    }),
    createGetScatterTooltipItemsNode(node, 'getTooltipItems', data.getTooltipItems, (newData) {
      suggestToChangeMe(data.copyWith(getTooltipItems: newData));
    }),
    createBooleanNode(node, 'fitInsideHorizontally', data.fitInsideHorizontally, (newData) {
      suggestToChangeMe(data.copyWith(fitInsideHorizontally: newData));
    }),
    createBooleanNode(node, 'fitInsideVertically', data.fitInsideVertically, (newData) {
      suggestToChangeMe(data.copyWith(fitInsideVertically: newData));
    }),
    createDoubleNode(node, 'rotateAngle', data.rotateAngle, (newData) {
      suggestToChangeMe(data.copyWith(rotateAngle: newData));
    })
  ]);
}
