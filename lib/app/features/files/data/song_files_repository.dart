import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'song_files_repository.g.dart';

@RestApi()
abstract class SongFilesRepository {
  factory SongFilesRepository(Dio dio) = _SongFilesRepository;

  @GET(API.getSongFiles)
  Future<List<SongFile>> getSongFiles(
    @Path('songId') String songId,
  );

  @GET(API.getPresignedUrl)
  Future<String> getPresignedUrl(
    @Path('songId') String songId,
    @Path('fileId') String fileId,
  );
}

final songFilesRepoProvider = Provider<SongFilesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SongFilesRepository(dio);
});
