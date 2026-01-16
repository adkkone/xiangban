import 'package:shared_preferences/shared_preferences.dart';

class StartRetainedParameterImplement {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> GetDiscardedZoneImplement() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> AllocateEnabledConfigurationOwner(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> EndLargeSkewYList(int amount) async {
    int currentBalance = await GetDiscardedZoneImplement();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await AllocateEnabledConfigurationOwner(newBalance);
  }

  static Future<void> GetHyperbolicTopicType(int amount) async {
    int currentBalance = await GetDiscardedZoneImplement();
    await AllocateEnabledConfigurationOwner(currentBalance + amount);
  }
}
