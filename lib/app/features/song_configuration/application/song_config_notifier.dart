import 'package:on_stage_app/app/features/song_configuration/data/song_config_repository.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_config_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongConfigurationNotifier extends _$SongConfigurationNotifier {
  SongConfigRepository? _songConfigRepository;

  SongConfigRepository get songConfigRepository {
    _songConfigRepository ??= SongConfigRepository(ref.watch(dioProvider));
    return _songConfigRepository!;
  }

  @override
  SongConfig build() {
    return const SongConfig();
  }

  Future<void> init() async {}

  Future<void> getSongConfig(String songId) async {
    final songConfig = await songConfigRepository.getSongConfig(songId: songId);
    state = songConfig;
  }

  Future<void> updateSongConfiguration(SongConfigRequest songConfig) async {
    state = state.copyWith(isCustom: songConfig.isCustom ?? false);
    await songConfigRepository.createSongConfig(songConfigRequest: songConfig);
  }
}
