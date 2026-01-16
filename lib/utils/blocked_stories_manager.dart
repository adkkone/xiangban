import 'package:shared_preferences/shared_preferences.dart';

class BlockedStoriesManager {
  static const String _key = 'blocked_stories';
  static BlockedStoriesManager? _instance;
  final SharedPreferences _prefs;

  BlockedStoriesManager._(this._prefs);

  static Future<BlockedStoriesManager> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = BlockedStoriesManager._(prefs);
    }
    return _instance!;
  }

  Future<Set<String>> getBlockedStories() async {
    final List<String>? blocked = _prefs.getStringList(_key);
    return blocked?.toSet() ?? {};
  }

  Future<void> blockStory(String storyId) async {
    final blocked = await getBlockedStories();
    blocked.add(storyId);
    await _prefs.setStringList(_key, blocked.toList());
  }

  Future<void> unblockStory(String storyId) async {
    final blocked = await getBlockedStories();
    blocked.remove(storyId);
    await _prefs.setStringList(_key, blocked.toList());
  }

  Future<bool> isStoryBlocked(String storyId) async {
    final blocked = await getBlockedStories();
    return blocked.contains(storyId);
  }
}
