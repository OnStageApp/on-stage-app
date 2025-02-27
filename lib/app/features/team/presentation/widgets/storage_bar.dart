import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/file_size_calculator.dart';

class StorageUsageBar extends StatelessWidget {
  const StorageUsageBar({
    this.usedStorage = 0,
    this.totalStorage = 1000,
    this.onTap,
    super.key,
  });

  final int usedStorage;
  final int totalStorage;
  final VoidCallback? onTap;

  double get usagePercentage => (usedStorage / totalStorage).clamp(0.0, 1.0);

  String get usedStorageFormatted {
    return FileSizeCalculator.formatSize(usedStorage);
  }

  String get totalStorageFormatted {
    return FileSizeCalculator.formatSize(totalStorage);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.onSurfaceVariant,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.hard_drive,
                    size: 20,
                    color: context.colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Storage',
                    style: context.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    '$usedStorageFormatted of $totalStorageFormatted',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  // Background track
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress indicator
                  FractionallySizedBox(
                    widthFactor: usagePercentage,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getColorBasedOnUsage(context),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorBasedOnUsage(BuildContext context) {
    if (usagePercentage < 0.7) {
      return context.colorScheme.primary;
    } else if (usagePercentage < 0.9) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
