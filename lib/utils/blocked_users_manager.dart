import 'package:shared_preferences/shared_preferences.dart';

class BlockedUsersManager {
  static const String _key = 'blocked_users';
  static BlockedUsersManager? _instance;
  static SharedPreferences? _prefs;

  BlockedUsersManager._();

  static Future<BlockedUsersManager> getInstance() async {
    if (_instance == null) {
      _instance = BlockedUsersManager._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<Set<String>> getBlockedUsers() async {
    final List<String>? blockedList = _prefs?.getStringList(_key);
    return blockedList?.toSet() ?? {};
  }

  Future<void> blockUser(String username) async {
    final blockedUsers = await getBlockedUsers();
    blockedUsers.add(username);
    await _prefs?.setStringList(_key, blockedUsers.toList());
  }

  Future<void> unblockUser(String username) async {
    final blockedUsers = await getBlockedUsers();
    blockedUsers.remove(username);
    await _prefs?.setStringList(_key, blockedUsers.toList());
  }

  Future<bool> isBlocked(String username) async {
    final blockedUsers = await getBlockedUsers();
    return blockedUsers.contains(username);
  }
}
