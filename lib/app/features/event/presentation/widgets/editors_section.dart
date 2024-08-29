import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditorsSection extends StatelessWidget {
  const EditorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Editor',
              style: context.textTheme.titleSmall,
            ),
            Text(
              'Invite members to manage',
              style: context.textTheme.titleSmall!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.smallNormal),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditorsTile(context, 'You', 'Admin'),
              const SizedBox(height: 12),
              _buildEditorsTile(context, 'Timotei George', 'Editor'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BlueActionButton(
          onTap: () {},
          text: 'Invite People',
          icon: Icons.add,
        ),
      ],
    );
  }

  Widget _buildEditorsTile(BuildContext context, String title, String role) {
    return Row(
      children: [
        Image.asset(
          'assets/images/profile1.png',
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: context.textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          role,
          style: context.textTheme.titleMedium!
              .copyWith(color: context.colorScheme.outline),
        ),
      ],
    );
  }
}
