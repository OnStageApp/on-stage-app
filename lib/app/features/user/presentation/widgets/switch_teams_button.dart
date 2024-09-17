import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/teams_selection_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SwitchTeamsButton extends StatelessWidget {
  const SwitchTeamsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        TeamsSelectionModal.show(context: context, onSave: () {});
      },
      child: Row(
        children: [
          Text(
            'Team',
            style: context.textTheme.titleSmall,
          ),
          const Spacer(),
          Text(
            'Switch',
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/arrow_down.svg',
            color: context.colorScheme.primary,
          )
        ],
      ),
    );
  }
}
