import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuRow extends StatefulWidget {
  final String text;
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDocumentsTap;

  const MenuRow({
    Key? key,
    required this.text,
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
    required this.onDocumentsTap,
  }) : super(key: key);

  @override
  State<MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<MenuRow> {
  bool get _showSelectedState => widget.isSelected;

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onHover: (bool hovered) {
          setState(() {
            isHovered = hovered;
          });
        },
        onTap: widget.onTap,
        child: SizedBox(
          height: AppDimens.menuRowHeight,
          child: Row(
            children: [
              const SizedBox(
                width: 36,
              ),
              SvgPicture.asset(
                widget.svgPath,
                width: AppDimens.menuIconSize,
                height: AppDimens.menuIconSize,
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                widget.text,
                style: TextStyle(
                  color: _showSelectedState ? AppColors.primary : Colors.white,
                  fontSize: AppDimens.menuTextSize,
                ),
              ),
              Expanded(child: Container()),
              _DocumentationIcon(onTap: widget.onDocumentsTap),
              const SizedBox(
                width: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentationIcon extends StatelessWidget {
  const _DocumentationIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(
          Icons.article,
          color: Colors.white,
        ),
        tooltip: 'Documentation',
      ),
    );
  }
}
