import 'package:on_stage_app/app/features/song_configuration/application/song_configuration_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_configuration_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongConfigurationNotifier extends _$SongConfigurationNotifier {
  bool isChorus = false;

  @override
  SongConfigurationState build() {
    return const SongConfigurationState();
  }

  Future<void> init() async {}
}
