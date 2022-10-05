import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DandylightCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 500,
    ),
  );
}