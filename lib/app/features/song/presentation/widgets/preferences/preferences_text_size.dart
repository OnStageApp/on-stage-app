import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/enums/text_size.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferencesTextSize extends ConsumerStatefulWidget {
  const PreferencesTextSize({super.key});

  @override
  PreferencesTextSizeState createState() => PreferencesTextSizeState();
}

class PreferencesTextSizeState extends ConsumerState<PreferencesTextSize> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text Size',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: Insets.small),
          Container(
            height: 48,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildTextSizeButton(context, TextSize.small),
                const Spacer(),
                _buildTextSizeButton(context, TextSize.normal),
                const Spacer(),
                _buildTextSizeButton(context, TextSize.large),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSizeButton(BuildContext context, TextSize textSize) {
    return InkWell(
      onTap: () {
        setState(() {
          ref.read(userSettingsNotifierProvider.notifier).setTextSize(textSize);
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: ref.watch(userSettingsNotifierProvider).textSize == textSize
              ? context.colorScheme.primary
              : context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'A',
          style: context.textTheme.titleMedium!.copyWith(
            color: ref.watch(userSettingsNotifierProvider).textSize == textSize
                ? context.colorScheme.onSurfaceVariant
                : context.colorScheme.onSurface,
            fontSize: textSize.size,
          ),
        ),
      ),
    );
  }
}
