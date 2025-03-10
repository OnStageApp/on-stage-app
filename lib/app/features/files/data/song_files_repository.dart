import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/domain/update_song_file_request.dart';
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

  @PUT(API.updateSongFile)
  Future<void> updateSongFile(
    @Path('fileId') String fileId,
    @Body() UpdateSongFileRequest request,
  );

  @DELETE(API.deleteSongFile)
  Future<void> deleteSongFile(
    @Path('fileId') String fileId,
  );

  @GET(API.getPresignedUrl)
  Future<String> getPresignedUrl(
    @Path('songId') String songId,
    @Path('fileId') String fileId,
  );

  @POST(API.uploadSongFile)
  @MultiPart()
  Future<SongFile> uploadSongFile(
    @Part(name: 'songId') String songId,
    @Part() File file,
  );

  @POST(API.uploadLink)
  Future<SongFile> uploadLink(
    @Path('songId') String songId,
    @Body() UpdateSongFileRequest request,
  );
}

final songFilesRepoProvider = Provider<SongFilesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SongFilesRepository(dio);
});
