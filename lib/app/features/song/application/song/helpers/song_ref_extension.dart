// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_stage_app/app/features/song/application/song/helpers/current_song_scope_provider.dart';
// import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
// import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
//
// extension SongRefExtension on WidgetRef {
//   /// Returns the current [SongState] based on the current scope.
//   SongState get songState {
//     final currentScope = watch(currentSongScopeProvider);
//     return watch(songNotifierProvider(currentScope));
//   }
//
//   /// Returns the [SongNotifier] instance for the current scope.
//   SongNotifier get songNotifier {
//     final currentScope = read(currentSongScopeProvider);
//     return read(songNotifierProvider(currentScope).notifier);
//   }
// }
