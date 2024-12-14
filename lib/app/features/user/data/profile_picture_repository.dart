import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:on_stage_app/app/utils/api.dart';

class ProfilePictureRepository {
  ProfilePictureRepository(this._dio);

  final Dio _dio;

  Future<void> updateUserImage(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      var mimeType = lookupMimeType(fileName);

      // Handle HEIF files
      if (fileExtension == 'heic' || fileExtension == 'heif') {
        mimeType = 'image/heif';
      }

      // Fallback for JPG files if mime type is not detected
      if (mimeType == null &&
          (fileExtension == 'jpg' || fileExtension == 'jpeg')) {
        mimeType =
            'image/jpeg'; // Note: Changed from 'image/jpg' to 'image/jpeg'
      }

      if (mimeType == null) {
        throw Exception('Could not determine file type');
      }

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.post(
        API.photo,
        data: formData,
        options: Options(
          headers: {
            'Cache-Control': 'no-cache',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            // Let Dio set the Content-Type header with the boundary
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
    } on DioException catch (e, s) {
      rethrow;
    } catch (e) {
      print('Unexpected error occurred: $e');
      rethrow;
    }
  }
}
