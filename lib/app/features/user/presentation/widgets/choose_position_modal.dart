// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';
// import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
// import 'package:on_stage_app/app/shared/continue_button.dart';
// import 'package:on_stage_app/app/shared/modal_header.dart';
// import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
// import 'package:on_stage_app/app/theme/theme.dart';
// import 'package:on_stage_app/app/utils/adaptive_modal.dart';
// import 'package:on_stage_app/app/utils/build_context_extensions.dart';
//
// class ChoosePositionModal extends ConsumerStatefulWidget {
//   const ChoosePositionModal({
//     required this.onSaved,
//     super.key,
//   });
//
//   final void Function(Position) onSaved;
//
//   @override
//   ChoosePositionModalState createState() => ChoosePositionModalState();
//
//   static void show({
//     required BuildContext context,
//     required void Function(Position) onSaved,
//   }) {
//     final modalKey = GlobalKey<ChoosePositionModalState>();
//     AdaptiveModal.show(
//       context: context,
//       child: SingleChildScrollView(
//         child: ChoosePositionModal(
//           key: modalKey,
//           onSaved: onSaved,
//         ),
//       ),
//     );
//   }
// }
//
// class ChoosePositionModalState extends ConsumerState<ChoosePositionModal> {
//   var _selectedPosition = Position.values.first;
//
//   Position get selectedPosition => _selectedPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         _selectedPosition =
//             ref.read(userNotifierProvider).currentUser?.position ??
//                 Position.values.first;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return NestedScrollModal(
//       buildHeader: () => const ModalHeader(title: 'Select Position'),
//       buildFooter: () => Container(
//         margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//         child: ContinueButton(
//           text: 'Save',
//           onPressed: () {
//             final selectedPosition = modalKey.currentState?.selectedPosition;
//             if (selectedPosition != null) {
//               onSaved(selectedPosition);
//             }
//             context.popDialog();
//           },
//           isEnabled: true,
//         ),
//       ),
//       headerHeight: () => 64,
//       footerHeight: () => 64,
//       buildContent: () => Padding(
//         padding: defaultScreenPadding,
//         child: ListView.builder(
//           itemCount: Position.values.length,
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return Column(
//               children: [
//                 _buildAlert(
//                   Position.values[index].title,
//                   () {
//                     _setPosition(Position.values[index]);
//                   },
//                   isSelected: Position.values[index] == _selectedPosition,
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 6),
//                   child: SizedBox(),
//                 ),
//                 if (index == Position.values.length - 1)
//                   const SizedBox(height: 24),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _setPosition(Position position) {
//     setState(() {
//       _selectedPosition = position;
//     });
//   }
//
//   Widget _buildAlert(
//     String position,
//     void Function() onTap, {
//     bool isSelected = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: context.colorScheme.onSurfaceVariant,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color:
//                 isSelected ? context.colorScheme.primary : Colors.transparent,
//             width: 1.6,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               position,
//               style: context.textTheme.titleSmall,
//             ),
//             if (isSelected)
//               Icon(
//                 Icons.check_circle,
//                 color: context.colorScheme.primary,
//                 size: 20,
//               )
//             else
//               Icon(
//                 Icons.circle_outlined,
//                 color: context.colorScheme.surfaceBright,
//                 size: 20,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
