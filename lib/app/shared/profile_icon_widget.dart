import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/notifications_bottom_sheet.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileIconWidget extends StatelessWidget {
  const ProfileIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  '2',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.background,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
