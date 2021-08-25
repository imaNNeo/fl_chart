import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/pages/editor/nodes/primitive/primitive_node_widgets.dart';
import 'package:fl_chart_app/pages/editor/nodes/primitive/primitive_nodes.dart';
import 'package:fl_chart_app/pages/widgets/treeview.dart';
import 'package:flutter/cupertino.dart';

import 'base_node_widgets.dart';

typedef SuggestToChangeMe<T> = void Function(T newData);

TreeNode<T> createAddNode<T>(
  TreeNode parent,
  String name,
  NodeClickListener onClick,
) {
  return TreeNode<T>(
    parentNode: parent,
    nodeId: name,
    widget: AddNodeWidget(name),
    data: null,
    onClick: onClick,
  );
}

TreeNode<FlTitlesData> createFlTitlesDataNode(
    TreeNode parent, String name, FlTitlesData data, SuggestToChangeMe<FlTitlesData> suggestToChangeMe) {
  final titlesDataNode = TreeNode(
    nodeId: name,
    widget: TextNodeWidget(name),
    data: data,
    parentNode: parent,
  );

  return titlesDataNode.copyWith(children: [
    createBooleanNode(titlesDataNode, 'show', data.show, (newShow) {
      suggestToChangeMe(data.copyWith(show: newShow));
    }),
    createSideTitlesNode(titlesDataNode, 'leftTitles', data.leftTitles, (newSideTitles) {
      suggestToChangeMe(data.copyWith(leftTitles: newSideTitles));
    }),
    createSideTitlesNode(titlesDataNode, 'topTitles', data.topTitles, (newSideTitles) {
      suggestToChangeMe(data.copyWith(topTitles: newSideTitles));
    }),
    createSideTitlesNode(titlesDataNode, 'rightTitles', data.rightTitles, (newSideTitles) {
      suggestToChangeMe(data.copyWith(rightTitles: newSideTitles));
    }),
    createSideTitlesNode(titlesDataNode, 'bottomTitles', data.bottomTitles, (newSideTitles) {
      suggestToChangeMe(data.copyWith(bottomTitles: newSideTitles));
    }),
  ]);
}

TreeNode<SideTitles> createSideTitlesNode(
  TreeNode parent,
  String name,
  SideTitles data,
  SuggestToChangeMe<SideTitles> suggestToChangeMe,
) {
  final sideTitlesNode = TreeNode<SideTitles>(
    nodeId: '$name',
    widget: TextNodeWidget('$name'),
    data: data,
    parentNode: parent,
    onClick: (context, node, depth) {},
  );
  return sideTitlesNode.copyWith(children: [
    createBooleanNode(sideTitlesNode, 'showTitles', data.showTitles, (newData) {
      suggestToChangeMe(data.copyWith(showTitles: newData));
    }),
    createGetTitleFunctionNode(sideTitlesNode, 'getTitles', data.getTitles, (newGetTitles) {}),
    createDoubleNode(sideTitlesNode, 'reservedSize', data.reservedSize, (newData) {
      suggestToChangeMe(data.copyWith(reservedSize: newData));
    }),
    createGetTitleTextStylesFunctionNode(sideTitlesNode, 'getTextStyles', data.getTextStyles, (newData) {}),
    createTextDirectionNode(sideTitlesNode, 'textDirection', data.textDirection, (newData) {
      suggestToChangeMe(data.copyWith(textDirection: newData));
    }),
    createDoubleNode(sideTitlesNode, 'margin', data.margin, (newData) {
      suggestToChangeMe(data.copyWith(margin: newData));
    }),
    createNullableDoubleNode(sideTitlesNode, 'interval', data.interval, (newData) {
      suggestToChangeMe(data.copyWith(margin: newData));
    }),
    createDoubleNode(sideTitlesNode, 'rotateAngle', data.rotateAngle, (newData) {
      suggestToChangeMe(data.copyWith(rotateAngle: newData));
    }),
    createCheckToShowTitleNode(sideTitlesNode, 'checkToShowTitle', data.checkToShowTitle, (newData) {}),
  ]);
}

TreeNode<TextDirection> createTextDirectionNode(
  TreeNode parent,
  String name,
  TextDirection data,
  SuggestToChangeMe<TextDirection> suggestToChangeMe,
) {
  return TreeNode(
    nodeId: name,
    widget: TextNodeWidget('$name: $data'),
    data: data,
    parentNode: parent,
  );
}

TreeNode<TextStyle> createTextStyleNode(
    TreeNode parent,
    String name,
    TextStyle data,
    SuggestToChangeMe<TextStyle> suggestToChangeMe,
    ) {
  return TreeNode(
    nodeId: name,
    widget: TextNodeWidget('$name: $data'),
    data: data,
    parentNode: parent,
  );
}

TreeNode<TextStyle?> createNullableTextStyleNode(
    TreeNode parent,
    String name,
    TextStyle? data,
    SuggestToChangeMe<TextStyle?> suggestToChangeMe,
    ) {
  return TreeNode(
    nodeId: name,
    widget: TextNodeWidget('$name: $data'),
    data: data,
    parentNode: parent,
  );
}

TreeNode<TextAlign> createTextAlignNode(
    TreeNode parent,
    String name,
    TextAlign data,
    SuggestToChangeMe<TextAlign> suggestToChangeMe,
    ) {
  return TreeNode(
    nodeId: name,
    widget: TextNodeWidget('$name: $data'),
    data: data,
    parentNode: parent,
  );
}

TreeNode<GetTitleFunction> createGetTitleFunctionNode(
  TreeNode parent,
  String name,
    GetTitleFunction data,
  SuggestToChangeMe<GetTitleFunction> suggestToChangeMe,
) {
  final getTitlesNode = TreeNode<GetTitleFunction>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
  return getTitlesNode;
}

TreeNode<GetTitleTextStyleFunction> createGetTitleTextStylesFunctionNode(
  TreeNode parent,
  String name,
  GetTitleTextStyleFunction data,
  SuggestToChangeMe<GetTitleTextStyleFunction> suggestToChangeMe,
) {
  return TreeNode<GetTitleTextStyleFunction>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
}

TreeNode<CheckToShowTitle> createCheckToShowTitleNode(
  TreeNode parent,
  String name,
  CheckToShowTitle data,
  SuggestToChangeMe<CheckToShowTitle> suggestToChangeMe,
) {
  return TreeNode<CheckToShowTitle>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
}

TreeNode<BaseTouchCallback<R>> createBaseTouchCallbackNode<R extends BaseTouchResponse>(
  TreeNode parent,
  String name,
  BaseTouchCallback<R>? data,
  SuggestToChangeMe<BaseTouchCallback<R>> suggestToChangeMe,
) {
  final touchCallbackNode = TreeNode<BaseTouchCallback<R>>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
  return touchCallbackNode;
}

TreeNode<MouseCursorResolver<R>> createMouseCursorResolverNode<R extends BaseTouchResponse>(
  TreeNode parent,
  String name,
  MouseCursorResolver<R>? data,
  SuggestToChangeMe<MouseCursorResolver<R>> suggestToChangeMe,
) {
  final touchCallbackNode = TreeNode<MouseCursorResolver<R>>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
  return touchCallbackNode;
}

TreeNode<GetDrawingGridLine> createGetDrawingGridLineNode(
  TreeNode parent,
  String name,
  GetDrawingGridLine data,
  SuggestToChangeMe<GetDrawingGridLine> suggestToChangeMe,
) {
  return TreeNode<GetDrawingGridLine>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
}

TreeNode<CheckToShowGrid> createCheckToShowGridNode(
  TreeNode parent,
  String name,
  CheckToShowGrid data,
  SuggestToChangeMe<CheckToShowGrid> suggestToChangeMe,
) {
  return TreeNode<CheckToShowGrid>(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
}

TreeNode createFlGridDataNode(
  TreeNode parent,
  String name,
  FlGridData data,
  SuggestToChangeMe<FlGridData> suggestToChangeMe,
) {
  final flGridDataNode = TreeNode<FlGridData>(
    nodeId: '$name',
    widget: TextNodeWidget('$name'),
    data: data,
    parentNode: parent,
    onClick: (context, node, depth) {},
  );
  return flGridDataNode.copyWith(children: [
    createBooleanNode(flGridDataNode, 'show', data.show, (newData) {
      suggestToChangeMe(data.copyWith(show: newData));
    }),
    createBooleanNode(flGridDataNode, 'drawHorizontalLine', data.drawHorizontalLine, (newData) {
      suggestToChangeMe(data.copyWith(drawHorizontalLine: newData));
    }),
    createNullableDoubleNode(flGridDataNode, 'horizontalInterval', data.horizontalInterval, (newData) {
      suggestToChangeMe(data.copyWith(horizontalInterval: newData));
    }),
    createGetDrawingGridLineNode(
        flGridDataNode, 'getDrawingHorizontalLine', data.getDrawingHorizontalLine, (newData) {}),
    createCheckToShowGridNode(
        flGridDataNode, 'checkToShowHorizontalLine', data.checkToShowHorizontalLine, (newData) {}),
    createBooleanNode(flGridDataNode, 'drawVerticalLine', data.drawVerticalLine, (newData) {
      suggestToChangeMe(data.copyWith(drawVerticalLine: newData));
    }),
    createNullableDoubleNode(flGridDataNode, 'verticalInterval', data.verticalInterval, (newData) {
      suggestToChangeMe(data.copyWith(verticalInterval: newData));
    }),
    createGetDrawingGridLineNode(flGridDataNode, 'getDrawingVerticalLine', data.getDrawingVerticalLine, (newData) {}),
    createCheckToShowGridNode(flGridDataNode, 'checkToShowVerticalLine', data.checkToShowVerticalLine, (newData) {}),
  ]);
}

TreeNode createFlBorderDataNode(
    TreeNode parent,
    String name,
    FlBorderData data,
    SuggestToChangeMe<FlBorderData> suggestToChangeMe,
    ) {
  final flBorderData = TreeNode<FlBorderData>(
    nodeId: '$name',
    widget: TextNodeWidget('$name'),
    data: data,
    parentNode: parent,
    onClick: (context, node, depth) {},
  );
  return flBorderData.copyWith(children: [
    createBooleanNode(flBorderData, 'show', data.show, (newData) {
      suggestToChangeMe(data.copyWith(show: newData));
    }),
    createBorderNode(flBorderData, 'border', data.border, (newData) {
      suggestToChangeMe(data.copyWith(border: newData));
    })
  ]);
}

TreeNode createAxisTitleNode(
    TreeNode parent,
    String name,
    AxisTitle data,
    SuggestToChangeMe<AxisTitle> suggestToChangeMe,
    ) {
  final axisTitleNode = TreeNode<AxisTitle>(
    nodeId: '$name',
    widget: TextNodeWidget('$name'),
    data: data,
    parentNode: parent,
    onClick: (context, node, depth) {},
  );
  return axisTitleNode.copyWith(children: [
    createBooleanNode(axisTitleNode, 'showTitle', data.showTitle, (newData) {
      suggestToChangeMe(data.copyWith(showTitle: newData));
    }),
    createTextNode(axisTitleNode, 'titleText', data.titleText, (newData) {
      suggestToChangeMe(data.copyWith(titleText: newData));
    }),
    createDoubleNode(axisTitleNode, 'reservedSize', data.reservedSize, (newData) {
      suggestToChangeMe(data.copyWith(reservedSize: newData));
    }),
    createNullableTextStyleNode(axisTitleNode, 'textStyle', data.textStyle, (newData) {
      suggestToChangeMe(data.copyWith(textStyle: newData));
    }),
    createTextAlignNode(axisTitleNode, 'textAlign', data.textAlign, (newData) {
      suggestToChangeMe(data.copyWith(textAlign: newData));
    }),
    createTextDirectionNode(axisTitleNode, 'textDirection', data.textDirection, (newData) {
      suggestToChangeMe(data.copyWith(textDirection: newData));
    }),
    createDoubleNode(axisTitleNode, 'margin', data.margin, (newData) {
      suggestToChangeMe(data.copyWith(margin: newData));
    })
  ]);
}

TreeNode createFlClipDataNode(
    TreeNode parent,
    String name,
    FlClipData data,
    SuggestToChangeMe<FlClipData> suggestToChangeMe,
    ) {
  final clipDataNode = TreeNode<FlClipData>(
    nodeId: '$name',
    widget: TextNodeWidget('$name'),
    data: data,
    parentNode: parent,
    onClick: (context, node, depth) {},
  );
  return clipDataNode.copyWith(children: [
    createBooleanNode(clipDataNode, 'top', data.top, (newData) {
      suggestToChangeMe(data.copyWith(top: newData));
    }),
    createBooleanNode(clipDataNode, 'bottom', data.bottom, (newData) {
      suggestToChangeMe(data.copyWith(bottom: newData));
    }),
    createBooleanNode(clipDataNode, 'left', data.left, (newData) {
      suggestToChangeMe(data.copyWith(left: newData));
    }),
    createBooleanNode(clipDataNode, 'right', data.right, (newData) {
      suggestToChangeMe(data.copyWith(right: newData));
    }),
  ]);
}

TreeNode createFlAxisTitleDataNode(
    TreeNode parent,
    String name,
    FlAxisTitleData data,
    SuggestToChangeMe<FlAxisTitleData> suggestToChangeMe,
    ) {
  final flAxisTitleDataNode = TreeNode<FlAxisTitleData>(
    nodeId: '$name',
    widget: TextNodeWidget('$name'),
    data: data,
    parentNode: parent,
    onClick: (context, node, depth) {},
  );
  return flAxisTitleDataNode.copyWith(children: [
    createBooleanNode(flAxisTitleDataNode, 'show', data.show, (newData) {
      suggestToChangeMe(data.copyWith(show: newData));
    }),
    createAxisTitleNode(flAxisTitleDataNode, 'leftTitle', data.leftTitle, (newData) {
      suggestToChangeMe(data.copyWith(leftTitle: newData));
    }),
    createAxisTitleNode(flAxisTitleDataNode, 'topTitle', data.topTitle, (newData) {
      suggestToChangeMe(data.copyWith(topTitle: newData));
    }),
    createAxisTitleNode(flAxisTitleDataNode, 'rightTitle', data.rightTitle, (newData) {
      suggestToChangeMe(data.copyWith(rightTitle: newData));
    }),
    createAxisTitleNode(flAxisTitleDataNode, 'bottomTitle', data.bottomTitle, (newData) {
      suggestToChangeMe(data.copyWith(bottomTitle: newData));
    }),
  ]);
}
