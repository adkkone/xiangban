import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyHeight = 'user_height';
  static const String _keyWeight = 'user_weight';
  static const String _keyInterests = 'user_interests';
  static const String _keyNickname = 'user_nickname';

  static UserService? _instance;
  final SharedPreferences _prefs;

  UserService._(this._prefs);

  static Future<UserService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = UserService._(prefs);
    }
    return _instance!;
  }

  // 检查是否完成引导
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // 保存引导完成状态
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_keyOnboardingCompleted, completed);
  }

  // 保存用户信息
  Future<void> saveUserProfile({
    String? height,
    String? weight,
    List<String>? interests,
    String? nickname,
  }) async {
    if (height != null) {
      await _prefs.setString(_keyHeight, height);
    }
    if (weight != null) {
      await _prefs.setString(_keyWeight, weight);
    }
    if (interests != null) {
      await _prefs.setStringList(_keyInterests, interests);
    }
    if (nickname != null) {
      await _prefs.setString(_keyNickname, nickname);
    }
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getUserProfile() async {
    return {
      'height': _prefs.getString(_keyHeight) ?? '170-180cm',
      'weight': _prefs.getString(_keyWeight) ?? '60-70kg',
      'interests': _prefs.getStringList(_keyInterests) ?? ['跑步', '力量训练', '瑜伽'],
      'nickname': _prefs.getString(_keyNickname) ?? '运动达人',
    };
  }

  // 清除所有用户数据（用于退出登录）
  Future<void> clearUserData() async {
    await _prefs.clear();
  }
}
