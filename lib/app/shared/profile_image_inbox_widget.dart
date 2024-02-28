import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/presentation/notification_page.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';

class ProfileImageInboxWidget extends ConsumerWidget {
  const ProfileImageInboxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        ));
      },
      child: const ProfileImageWidget(),
    );
  }
}
