import 'package:shared_preferences/shared_preferences.dart';

class TeenModeService {
  static const String _keyTeenMode = 'teen_mode_enabled';
  
  static TeenModeService? _instance;
  final SharedPreferences _prefs;

  TeenModeService._(this._prefs);

  static Future<TeenModeService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = TeenModeService._(prefs);
    }
    return _instance!;
  }

  // 获取青少年模式状态
  Future<bool> isTeenModeEnabled() async {
    return _prefs.getBool(_keyTeenMode) ?? false;
  }

  // 设置青少年模式状态
  Future<void> setTeenMode(bool enabled) async {
    await _prefs.setBool(_keyTeenMode, enabled);
  }
}
