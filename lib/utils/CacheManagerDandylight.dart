import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerDandylight {
  /// private constructor
  CacheManagerDandylight._();
  /// the one and only instance of this singleton
  static final instance = CacheManagerDandylight._();

  DefaultCacheManager getDefaultManager() {
    return DefaultCacheManager();
  }
}