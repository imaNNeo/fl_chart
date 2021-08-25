import 'package:fl_chart_app/widgets/my_column.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TreeViewer<T> extends StatefulWidget {
  final TreeNode<T> root;
  final double initialPadding;
  final double depthPadding;
  final double nodeHeight;
  final double width;
  final Color iconColor;

  const TreeViewer({
    Key? key,
    required this.root,
    this.initialPadding = 16.0,
    this.depthPadding = 16.0,
    this.nodeHeight = 36.0,
    this.width = 200,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  _TreeViewerState createState() => _TreeViewerState();
}

class _TreeViewerState extends State<TreeViewer> {
  late Map<String, bool> _expansionState;

  @override
  void initState() {
    _expansionState = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rows = <Widget>[];

    void appendRowRecursively(TreeNode node, int depth) {
      rows.add(
        Listener(
          onPointerDown: (event) {
            // Check if right mouse button clicked
            if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
              if (node.onRightClick != null) {
                node.onRightClick!(context, node, depth, event);
              }
            }
          },
          child: InkWell(
            onTap: () {
              setState(() {
                if (node.children.isEmpty) {
                  if (node.onClick != null) {
                    node.onClick!(context, node, depth);
                  }
                  return;
                }
                if (_expansionState[node.nodeId] == true) {
                  _expansionState[node.nodeId] = false;
                } else {
                  _expansionState[node.nodeId] = true;
                }
              });
            },
            child: Container(
              height: widget.nodeHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: widget.initialPadding + (widget.depthPadding * depth)),
                  if (node.children.isNotEmpty)
                    Icon(
                      _expansionState[node.nodeId] == true ? Icons.expand_more : Icons.chevron_right_outlined,
                      size: 18,
                      color: widget.iconColor,
                    ),
                  const SizedBox(width: 4),
                  node.widget,
                ],
              ),
            ),
          ),
        ),
      );

      if (_expansionState[node.nodeId] == true) {
        for (final child in node.children) {
          appendRowRecursively(child, depth + 1);
        }
      }
    }

    appendRowRecursively(widget.root, 0);

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Material(
          color: Colors.transparent,
          child: MyColumn(
            minWidth: widget.width,
            rightPadding: 18,
            children: rows,
          ),
        ),
      ),
    );
  }
}

typedef NodeClickListener = void Function(BuildContext context, TreeNode node, int depth);

typedef NodeRightClickListener = void Function(BuildContext context, TreeNode node, int depth, PointerDownEvent event);

/// Node of a tree, representing one Widget
class TreeNode<T> {
  final String nodeId;

  final Widget widget;

  /// Descendant nodes.
  final List<TreeNode> children;

  final NodeClickListener? onClick;

  final NodeRightClickListener? onRightClick;

  final TreeNode? parentNode;

  final T? data;

  String get universalId {
    var universalId = nodeId;
    var parent = parentNode;
    while (parent != null) {
      universalId = '${parent.nodeId}.$universalId';
      parent = parent.parentNode;
    }
    return universalId;
  }

  TreeNode? get findRootNode {
    if (parentNode == null) {
      return this;
    }
    var parent = parentNode;
    while (parent != null) {
      parent = parent.parentNode;
    }
    return parent;
  }

  TreeNode({
    required this.nodeId,
    required this.widget,
    required this.parentNode,
    required this.data,
    this.children = const [],
    this.onClick,
    this.onRightClick,
  });

  TreeNode<T> copyWith({
    String? nodeId,
    Widget? widget,
    List<TreeNode>? children,
    NodeClickListener? onClick,
    NodeRightClickListener? onRightClick,
    TreeNode? parentNode,
    T? data,
  }) {
    return TreeNode<T>(
      nodeId: nodeId ?? this.nodeId,
      widget: widget ?? this.widget,
      children: children ?? this.children,
      onClick: onClick ?? this.onClick,
      onRightClick: onRightClick ?? this.onRightClick,
      parentNode: parentNode ?? this.parentNode,
      data: data ?? this.data,
    );
  }
}
