import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'artists_state.dart';

part 'artists_notifier.g.dart';

@Riverpod(keepAlive: true)
class AritstsNotifier extends _$AritstsNotifier {
  @override
  ArtistsState build() {
    return const ArtistsState();
  }
}