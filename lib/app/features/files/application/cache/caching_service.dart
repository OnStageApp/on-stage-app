import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/features/files/application/cache/custom_cache_manager.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/logger.dart';

final cachingServiceProvider = Provider<CachingService>((ref) {
  return CachingService();
});

class CachingService {
  final CacheManager _cacheManager = CustomCacheManager();

  Future<String?> cacheFile(
    String url,
    String fileId,
    String fileName,
    String extension,
    FileTypeEnum fileType,
  ) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(fileId);

      if (fileInfo != null) {
        logger.i('Using cached file: ${fileInfo.file.path}');
        return fileInfo.file.path;
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final file = await _cacheManager.putFile(
          fileId,
          response.bodyBytes,
          fileExtension: extension,
        );
        logger.i('File cached at: ${file.path}');
        return file.path;
      } else {
        logger.e('Failed to download file: ${response.statusCode}');
        return null;
      }
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
      final fileInfo = await _cacheManager.getFileFromCache(fileId);

      if (fileInfo != null) {
        logger.i('File found in cache: ${fileInfo.file.path}');
        return fileInfo.file.path;
      }

      logger.i('File not found in cache for ID: $fileId');
      return null;
    } catch (e) {
      logger.e('Error checking cache: $e');
      return null;
    }
  }

  Future<void> cleanupCache() async {
    try {
      await _cacheManager.emptyCache();
      logger.i('Cache cleared successfully.');
    } catch (e) {
      logger.e('Error clearing cache: $e');
    }
  }
}
