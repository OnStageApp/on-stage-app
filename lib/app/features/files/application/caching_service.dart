import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path_provider/path_provider.dart';

final cachingServiceProvider = Provider<CachingService>((ref) {
  return CachingService();
});

class CachingService {
  Future<String?> cacheFile(
    String url,
    String fileId,
    String fileName,
    String extension,
    FileTypeEnum fileType,
  ) async {
    try {
      final appDir = await getApplicationCacheDirectory();
      final fileDir = Directory(
        '${appDir.path}/files',
      );
      if (!fileDir.existsSync()) {
        await fileDir.create(recursive: true);
      }

      final cachedFilePath = '${fileDir.path}/$fileId.$extension';
      final cachedFile = File(cachedFilePath);

      if (!cachedFile.existsSync()) {
        final response = await http.get(Uri.parse(url));
        await cachedFile.writeAsBytes(response.bodyBytes);
        logger.i('File downloaded to: $cachedFilePath');
      } else {
        logger.i('Using cached file: $cachedFilePath');
      }

      return cachedFilePath;
    } catch (e) {
      logger.e('Error caching file: $e');
      return null;
    }
  }

  Future<String?> checkCache(
    String fileId,
    String fileName,
    String extension,
    FileTypeEnum fileType,
  ) async {
    try {
      final appDir = await getApplicationCacheDirectory();
      final fileDir = Directory(
        '${appDir.path}/${fileType == FileTypeEnum.audio ? 'audio' : 'documents'}',
      );

      final cachedFilePath = '${fileDir.path}/$fileId.$extension';
      final cachedFile = File(cachedFilePath);

      if (cachedFile.existsSync()) {
        return cachedFilePath;
      }

      logger.i('File succesfully cached '
          ': ${cachedFilePath.isNotNullEmptyOrWhitespace}');
      return null;
    } catch (e) {
      logger.e('Error checking cache: $e');
      return null;
    }
  }

  Future<void> cleanupCache({int maxAgeInDays = 3}) async {
    try {
      final appDir = await getApplicationCacheDirectory();
      final fileDir = Directory('${appDir.path}/documents');

      if (fileDir.existsSync()) {
        final now = DateTime.now();
        await for (final entity in fileDir.list()) {
          if (entity is File) {
            final fileStat = entity.statSync();
            final fileAge = now.difference(fileStat.modified);

            if (fileAge.inDays > maxAgeInDays) {
              await entity.delete();
              logger.i('Deleted old cached file: ${entity.path}');
            }
          }
        }
      }
    } catch (e) {
      logger.e('Error cleaning up cache: $e');
    }
  }
}
