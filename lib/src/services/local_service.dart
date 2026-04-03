import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static const String _tokenKey = 'token';
  static const String _expireKey = 'token_expire';

  /// Save token with expiry time (in hours)
  Future<void> saveToken(String token, {int hours = 24}) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime =
        DateTime.now().add(Duration(hours: hours)).millisecondsSinceEpoch;

    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_expireKey, expiryTime);
  }

  /// Get valid token (returns null if expired or not found)
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expire = prefs.getInt(_expireKey);

    if (token == null || expire == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > expire) {
      // Token expired — remove it
      await removeToken();
      return null;
    }

    return token;
  }

  /// Remove token completely
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expireKey);
  }
}
