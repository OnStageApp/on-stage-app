import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/shared/notifications_bottom_sheet.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileIconWidget extends ConsumerWidget {
  const ProfileIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => NotificationsBottomSheet.show(context),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/profile4.png',
            width: 64,
            height: 64,
            fit: BoxFit.fill,
          ),
          Positioned(
            left: -2,
            bottom: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: context.colorScheme.background,
                    width: 2,
                  ),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  ref.watch(notificationNotifierProvider).length.toString(),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.background,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
