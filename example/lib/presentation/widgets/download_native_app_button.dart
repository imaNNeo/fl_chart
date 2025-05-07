import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class DownloadNativeAppButton extends StatelessWidget {
  const DownloadNativeAppButton({
    super.key,
    required this.onClose,
    required this.onDownload,
  });

  final VoidCallback onClose;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.contentColorYellow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onDownload,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 4),
                const Icon(
                  size: 28,
                  Icons.download_for_offline,
                  color: AppColors.contentColorBlack,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Download Native App',
                  style: TextStyle(
                    color: AppColors.contentColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    size: 16,
                    Icons.close,
                    color: AppColors.contentColorBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
