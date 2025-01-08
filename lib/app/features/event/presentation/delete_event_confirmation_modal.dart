// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
// import 'package:on_stage_app/app/router/app_router.dart';
// import 'package:on_stage_app/app/utils/build_context_extensions.dart';
//
// class DeleteEventConfirmationDialog extends ConsumerWidget {
//   const DeleteEventConfirmationDialog({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (Platform.isAndroid) {
//       return AlertDialog(
//         title: _buildTitle(),
//         content: _buildContent(),
//         actions: [
//           TextButton(
//             onPressed: () {
//               context.popDialog();
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               await _removeEvent(ref, context);
//               context.popDialog();
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       );
//     } else {
//       return CupertinoAlertDialog(
//         title: _buildTitle(),
//         content: _buildContent(),
//         actions: [
//           CupertinoDialogAction(
//             onPressed: () {
//               context.popDialog();
//             },
//             child: const Text('Cancel'),
//           ),
//           CupertinoDialogAction(
//             onPressed: () async {
//               await _removeEvent(ref, context);
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       );
//     }
//   }
//
//   Future<void> _removeEvent(WidgetRef ref, BuildContext context) async {
//     await ref.read(eventNotifierProvider.notifier).deleteEventAndGetAll();
//     context
//       ..popDialog()
//       ..pushReplacementNamed(AppRoute.events.name);
//   }
//
//   Text _buildTitle() => const Text('Delete event');
//
//   Text _buildContent() {
//     return const Text(
//       'Are you sure you want to delete this event? ',
//     );
//   }
//
//   static Future<bool?> show({required BuildContext context}) {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) => const DeleteEventConfirmationDialog(),
//     );
//   }
// }
