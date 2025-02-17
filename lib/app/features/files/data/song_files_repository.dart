import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:retrofit/retrofit.dart';

part 'song_files_repository.g.dart';

@RestApi()
abstract class SongFilesRepository {
  factory SongFilesRepository(Dio dio) = _SongFilesRepository;

  @GET('/songs')
  Future<List<SongFile>> getSongFiles();

  @POST('/songs/upload')
  Future<String> getUploadUrl(@Body() Map<String, dynamic> fileInfo);

  @DELETE('/songs/{id}')
  Future<void> deleteSongFile(@Path('id') String id);

  @PUT('/songs/{id}/play')
  Future<String> getStreamUrl(@Path('id') String id);
}

final songFilesRepoProvider = Provider<SongFilesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SongFilesRepository(dio);
});
