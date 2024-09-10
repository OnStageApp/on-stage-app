import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:on_stage_app/app/utils/api.dart';

class ProfilePictureRepository {
  final Dio _dio;

  ProfilePictureRepository(this._dio);

  Future<void> updateUserImage(String userId, File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      String? mimeType = lookupMimeType(fileName);

      print('Uploading image:');
      print('  File name: $fileName');
      print('  File extension: $fileExtension');
      print('  Detected MIME type: $mimeType');
      print('  File size: ${await imageFile.length()} bytes');

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

      print('  Final MIME type: $mimeType');

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.post(
        '${API.users}/$userId/photo',
        data: formData,
        options: Options(
          headers: {
            "Cache-Control": "no-cache",
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate, br",
            "Connection": "keep-alive",
            // Let Dio set the Content-Type header with the boundary
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Server response:');
      print('  Status code: ${response.statusCode}');
      print('  Response data: ${response.data}');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      print('Image upload successful');
    } on DioException catch (e, s) {
      print('DioException occurred: $s');
      print('  Type: ${e.type}');
      print('  Message: ${e.message}');
      print('  Status code: ${e.response?.statusCode}');
      print('  Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error occurred: $e');
      rethrow;
    }
  }
}
