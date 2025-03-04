import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  CustomCacheManager()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 5),
            maxNrOfCacheObjects: 20,
            repo: JsonCacheInfoRepository(),
          ),
        );
  static const key = 'song-files-cache';
}
