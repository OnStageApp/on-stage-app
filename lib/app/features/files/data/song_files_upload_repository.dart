import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';

class SongFilesUploadRepository {
  SongFilesUploadRepository(this._dio);
  final Dio _dio;

  Future<SongFile> uploadSongFile(String songId, MultipartFile file) async {
    try {
      logger.i('Uploading file: $file');
      final formData = FormData.fromMap({
        'file': file,
      });

      logger.i('Uploading file: ${file.filename}');
      final response = await _dio.post(
        API.uploadSongFile.replaceAll('{songId}', songId),
        data: formData,
        options: Options(
          headers: {
            'Accept': '*/*',
            'Connection': 'keep-alive',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      return SongFile.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      logger.e('Error uploading file: $e');
      rethrow;
    }
  }
}

final songFilesUploadRepoProvider = Provider<SongFilesUploadRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SongFilesUploadRepository(dio);
});
