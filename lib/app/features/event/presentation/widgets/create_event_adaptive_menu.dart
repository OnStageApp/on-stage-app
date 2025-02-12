import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/presentation/event_templates_modal.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';

class CreateEventAdaptiveMenu extends ConsumerWidget {
  const CreateEventAdaptiveMenu({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveMenuContext(
      width: 24,
      items: [
        MenuAction(
          title: 'Add New Event',
          icon: LucideIcons.calendar_plus,
          onTap: () async {
            if (ref.watch(permissionServiceProvider).canAddEvents) {
              await ref.read(eventNotifierProvider.notifier).createEmptyEvent();
              if (context.mounted) {
                unawaited(context.pushNamed(AppRoute.addEvent.name));
              }
            } else {
              PaywallModal.show(
                context: context,
                permissionType: PermissionType.addEvents,
              );
            }
          },
        ),
        MenuAction(
          title: 'Add from Templates',
          onTap: () => {
            EventTemplatesModal.show(
              context: context,
              onEventTemplateSelected: () {
                if (context.mounted) {
                  unawaited(context.pushNamed(AppRoute.addEvent.name));
                }
              },
            ),
          },
          icon: LucideIcons.folders,
        ),
      ],
      child: child,
    );
  }
}
