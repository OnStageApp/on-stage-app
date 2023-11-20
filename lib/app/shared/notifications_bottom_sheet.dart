import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/shared/close_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationsBottomSheet extends ConsumerWidget {
  const NotificationsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: context.colorScheme.background,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const CloseHeader(
          title: NotificationsCloseHeader(),
        ),
        headerHeight: () => CloseHeader.height,
        footerHeight: () => 59,
        buildContent: () => const NotificationsBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationNotifierProvider);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: notifications.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Yesterday',
                        style: context.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.colorScheme.secondary.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            notifications[index].title,
                            style: context.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            notifications[index].body,
                            style: context.textTheme.bodySmall!.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/images/profile4.png',
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: notifications.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            )
          : const Center(
              child: Text('No notifications'),
            ),
    );
  }
}

class NotificationsCloseHeader extends ConsumerWidget {
  const NotificationsCloseHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Inbox',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: context.colorScheme.background,
                      width: 2,
                    ),
                  ),
                ),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    ref.watch(notificationNotifierProvider).length.toString(),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.background,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
