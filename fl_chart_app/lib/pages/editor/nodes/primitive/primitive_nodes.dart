import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/pages/editor/dialogs/editor_dialogs.dart';
import 'package:fl_chart_app/pages/widgets/treeview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../base/base_nodes.dart';
import 'primitive_node_widgets.dart';

TreeNode<String> createTextNode(
  TreeNode parent,
  String name,
  String text,
  SuggestToChangeMe<String> suggestToChangeMe, {
  String? data,
}) {
  final boolNode = TreeNode<String>(
    nodeId: name,
    widget: TextNodeWidget(name.isEmpty ? text : '$name: $text'),
    parentNode: parent,
    data: data,
  );
  return boolNode;
}

TreeNode<bool> createBooleanNode(
  TreeNode parent,
  String name,
  bool data,
  SuggestToChangeMe<bool> suggestToChangeMe,
) {
  final boolNode = TreeNode<bool>(
    nodeId: name,
    widget: BoolNodeWidget(name, data, (newValue) {
      suggestToChangeMe(newValue);
    }),
    parentNode: parent,
    data: data,
    onClick: (context, node, depth) {
      suggestToChangeMe(!data);
    },
  );
  return boolNode;
}

TreeNode<int> createIntNode(
  TreeNode parent,
  String name,
  int data,
  SuggestToChangeMe<int> suggestToChangeMe, {
  String? showingKey,
}) {
  final boolNode = TreeNode<int>(
    nodeId: name,
    widget: IntNodeWidget(showingKey ?? name, data),
    parentNode: parent,
    data: data,
  );
  return boolNode;
}

TreeNode<double> createDoubleNode(
  TreeNode parent,
  String name,
  double data,
  SuggestToChangeMe<double> suggestToChangeMe,
) {
  final doubleNode = TreeNode<double>(
    nodeId: name,
    widget: DoubleNodeWidget(name, data),
    parentNode: parent,
    data: data,
    onClick: (context, node, depth) async {
      final newData = await showDoubleDialog(context, name, data, onHotChange: (newValue) {
        suggestToChangeMe(newValue);
      });
      suggestToChangeMe(newData);
    }
  );
  return doubleNode;
}

TreeNode<double?> createNullableDoubleNode(
    TreeNode parent,
    String name,
    double? data,
    SuggestToChangeMe<double?> suggestToChangeMe,
    ) {
  final doubleNode = TreeNode<double?>(
    nodeId: name,
    widget: NullableDoubleNodeWidget(name, data, (newDouble) {
      suggestToChangeMe(data);
    }),
    parentNode: parent,
    data: data,
    onClick: null,
  );
  return doubleNode;
}

TreeNode<List<int>> createIntListNode(
  TreeNode parent,
  String name,
  List<int> data,
  SuggestToChangeMe<List<int>> suggestToChangeMe,
) {
  final intListNode = TreeNode<List<int>>(
    nodeId: name,
    widget: TextNodeWidget(name),
    data: data,
    parentNode: parent,
  );

  final childNodes = data.asMap().entries.map((entry) {
    final index = entry.key;
    final value = entry.value;
    return createIntNode(intListNode, index.toString(), value, (newValue) {
      final newData = List.of(data);
      newData[index] = newValue;
      suggestToChangeMe(newData);
    }, showingKey: '');
  }).toList();

  return intListNode.copyWith(
    children: childNodes +
        [
          createAddNode<int>(
            intListNode,
            'Add',
            (context, node, depth) {
              final newNumber = data.isNotEmpty ? data.last + 1 : 0;
              suggestToChangeMe(data + [newNumber]);
            },
          )
        ],
  );
}

TreeNode<Color> createColorNode(
    TreeNode parent,
    String name,
    Color data,
    SuggestToChangeMe<Color> suggestToChangeMe,
    ) {
  return TreeNode<Color>(
    nodeId: name,
    widget: ColorNodeWidget(name, data),
    parentNode: parent,
    data: data,
    onClick: (context, node, depth) async {
      final newColor = await showColorPickerDialog(context, defaultColor: data);
      suggestToChangeMe(newColor);
    }
  );
}

TreeNode<EdgeInsets> createEdgeInsetsNode(
    TreeNode parent,
    String name,
    EdgeInsets data,
    SuggestToChangeMe<EdgeInsets> suggestToChangeMe,
    ) {
  return TreeNode(
    nodeId: name,
    widget: EdgeInsetsNodeWidget(name, data, suggestToChangeMe),
    parentNode: parent,
    data: data,
  );
}

TreeNode<BorderSide> createBorderSideNode(
    TreeNode parent,
    String name,
    BorderSide data,
    SuggestToChangeMe<BorderSide> suggestToChangeMe,
    ) {
  final borderSideNode = TreeNode(
    nodeId: name,
    widget: TextNodeWidget(name),
    parentNode: parent,
    data: data,
  );
  return borderSideNode.copyWith(
    children: [
      createColorNode(borderSideNode, 'color', data.color, (newData) {
        suggestToChangeMe(data.copyWith(color: newData));
      }),
      createDoubleNode(borderSideNode, 'width', data.width, (newData) {
        suggestToChangeMe(data.copyWith(width: newData));
      })
    ]
  );
}

extension on Border {
  Border copyWith({
    BorderSide? top,
    BorderSide? right,
    BorderSide? bottom,
    BorderSide? left,
  }) {
    return Border(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }
}

TreeNode<Border> createBorderNode(
    TreeNode parent,
    String name,
    Border data,
    SuggestToChangeMe<Border> suggestToChangeMe,
    ) {
  final borderNode = TreeNode(
    nodeId: name,
    widget: BorderNodeWidget(name, data, suggestToChangeMe),
    parentNode: parent,
    data: data,
  );
  return borderNode.copyWith(
    children: [
      createBorderSideNode(borderNode, 'left', data.left, (newData) {
        suggestToChangeMe(data.copyWith(left: newData));
      }),
      createBorderSideNode(borderNode, 'top', data.top, (newData) {
        suggestToChangeMe(data.copyWith(top: newData));
      }),
      createBorderSideNode(borderNode, 'right', data.right, (newData) {
        suggestToChangeMe(data.copyWith(right: newData));
      }),
      createBorderSideNode(borderNode, 'bottom', data.bottom, (newData) {
        suggestToChangeMe(data.copyWith(bottom: newData));
      }),
    ]
  );
}

