import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _keyFavorites = 'user_favorites';
  
  static FavoritesService? _instance;
  final SharedPreferences _prefs;

  FavoritesService._(this._prefs);

  static Future<FavoritesService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = FavoritesService._(prefs);
    }
    return _instance!;
  }

  // 获取所有收藏的训练ID
  Future<List<String>> getFavoriteIds() async {
    final List<String>? favorites = _prefs.getStringList(_keyFavorites);
    return favorites ?? [];
  }

  // 添加收藏
  Future<void> addFavorite(String workoutId) async {
    final favorites = await getFavoriteIds();
    if (!favorites.contains(workoutId)) {
      favorites.add(workoutId);
      await _prefs.setStringList(_keyFavorites, favorites);
    }
  }

  // 移除收藏
  Future<void> removeFavorite(String workoutId) async {
    final favorites = await getFavoriteIds();
    favorites.remove(workoutId);
    await _prefs.setStringList(_keyFavorites, favorites);
  }

  // 检查是否已收藏
  Future<bool> isFavorite(String workoutId) async {
    final favorites = await getFavoriteIds();
    return favorites.contains(workoutId);
  }

  // 切换收藏状态
  Future<bool> toggleFavorite(String workoutId) async {
    final isFav = await isFavorite(workoutId);
    if (isFav) {
      await removeFavorite(workoutId);
      return false;
    } else {
      await addFavorite(workoutId);
      return true;
    }
  }

  // 获取收藏数量
  Future<int> getFavoriteCount() async {
    final favorites = await getFavoriteIds();
    return favorites.length;
  }
}
