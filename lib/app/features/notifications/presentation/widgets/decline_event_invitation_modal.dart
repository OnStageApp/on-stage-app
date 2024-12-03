import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DeclineEventInvitationModal extends ConsumerStatefulWidget {
  const DeclineEventInvitationModal({
    required this.onDeclineInvitation,
    super.key,
  });

  final void Function() onDeclineInvitation;

  @override
  DeclineEventInvitationModalState createState() =>
      DeclineEventInvitationModalState();

  static void show({
    required BuildContext context,
    required void Function() onDeclineInvitation,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Preferences'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: DeclineEventInvitationModal(
              onDeclineInvitation: onDeclineInvitation,
            ),
          ),
        ),
      ),
    );
  }
}

class DeclineEventInvitationModalState
    extends ConsumerState<DeclineEventInvitationModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              minimumSize: const Size(double.infinity, 40),
              // width, height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              widget.onDeclineInvitation();
            },
            child: Text(
              'Decline Invitation',
              textAlign: TextAlign.start,
              style: context.textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: context.colorScheme.onSurfaceVariant,

              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              minimumSize: const Size(double.infinity, 40),
              // width, height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.popDialog();
            },
            child: Text(
              'Cancel',
              textAlign: TextAlign.start,
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
