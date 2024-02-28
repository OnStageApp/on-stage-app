// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
// import 'package:on_stage_app/app/shared/build_devider.dart';
// import 'package:on_stage_app/app/shared/close_header.dart';
// import 'package:on_stage_app/app/shared/custom_app_bar.dart';
// import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
// import 'package:on_stage_app/app/utils/build_context_extensions.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);
//
//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final notifications = ref.watch(notificationNotifierProvider);
//         return Scaffold(
//           appBar: customAppBar(
//             context,
//             'Notifications',
//             canBack: true,
//             onBack: () {
//               Navigator.pop(context);
//             },
//           ),
//           body: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: notifications.isNotEmpty
//                 ? ListView.builder(
//                     itemBuilder: (context, index) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             color: index == 0
//                                 ? context.colorScheme.secondary.withOpacity(0.2)
//                                 : null,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: index == 0
//                                           ? Border.all(
//                                               color: Colors.white, width: 2)
//                                           : null,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/images/profile4.png',
//                                       width: 32,
//                                       height: 32,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           notifications[index].title,
//                                           style: context.textTheme.bodyMedium,
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           notifications[index].body,
//                                           style: context.textTheme.bodySmall!
//                                               .copyWith(
//                                             color: context.colorScheme.outline,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           if (index != notifications.length - 1)
//                             buildDivider(context),
//                         ],
//                       );
//                     },
//                     itemCount: notifications.length,
//                     shrinkWrap: true,
//                     physics: const ClampingScrollPhysics(),
//                   )
//                 : const Center(
//                     child: Text('No notifications'),
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/shared/build_devider.dart';
import 'package:on_stage_app/app/shared/close_header.dart';
import 'package:on_stage_app/app/shared/custom_app_bar.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifications = ref.watch(notificationNotifierProvider);
        return Scaffold(
          appBar: customAppBar(
            context,
            'Notifications',
            canBack: true,
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: notifications.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          // Apply background color only for the first item
                          color: index == 0
                              ? context.colorScheme.secondary.withOpacity(0.2)
                              : null,
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
                            leading: Container(
                              decoration: BoxDecoration(
                                border: index == 0
                                    ? Border.all(
                                        color: Colors.white, width: 2)
                                    : null,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/profile4.png',
                                width: 42,
                                height: 42,
                              ),
                            ),
                          ),
                        ),
                        // Do not display the divider for the last item
                        if (index != notifications.length - 1)
                          buildDivider(context),
                      ],
                    );
                  },
                  itemCount: notifications.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                )
              : const Center(
                  child: Text('No notifications'),
                ),
        );
      },
    );
  }
}
