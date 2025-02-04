// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_stage_app/app/features/song/application/song/helpers/current_song_scope_provider.dart';
// import 'package:on_stage_app/app/features/song/application/song/helpers/song_scope.dart';
//
// class EventsScopeWrapper extends StatelessWidget {
//   const EventsScopeWrapper({required this.child, super.key});
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return ProviderScope(
//       overrides: [
//         currentSongScopeProvider.overrideWithValue(SongScope.eventsTab),
//       ],
//       child: child,
//     );
//   }
// }
