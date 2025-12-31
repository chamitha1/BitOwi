import 'package:shared_preferences/shared_preferences.dart';

const String userToken = 'user_token';
const String userName = 'user_name';
const String userId = 'user_id';
const String userAccountNumber = 'account_number';
const String currency = '_currency';
const String symbol = '_symbol';
const merchantSucTip = '_merchantSucTip';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  //set user token


  //get user token
  static Future<String?> getToken() async {
    if (_prefs == null) await init();
    final token = _prefs!.getString(userToken);
    print("GETTING TOKEN : $token ");
    return token;
  }

  static Future<void> removeToken() async {
    if (_prefs == null) await init();
    await _prefs!.remove(userToken);
  }

  //set user name
  static Future<bool> saveUserName(String name) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(userName, name);
  }

  //get user name
  static Future<String?> getUserName() async {
    if (_prefs == null) await init();
    return _prefs!.getString(userName);
  }

  //set user id
  static Future<bool> saveUserId(String idString) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(userName, idString);
  }

  //get user id
  static Future<String?> getUserId() async {
    if (_prefs == null) await init();
    return _prefs!.getString(userId);
  }

  static Future<bool> saveAccountNumber(String accNum) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(userAccountNumber, accNum);
  }

  static Future<String?> getAccountNumber() async {
    if (_prefs == null) await init();
    return _prefs!.getString(userAccountNumber);
  }

  // set currency
  static Future<bool> setCurrency(String _currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(currency, _currency);
  }

  /// Get currency
  static Future<String> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(currency);
    return value ?? 'NGN'; // Default to NGN if not set
  }

  /// Set symbol
  static Future<bool> setSymbol(String _symbol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(symbol, _symbol);
  }

  /// Get symbol
  static Future<String> getSymbol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(symbol);
    return value ?? 'USDT'; // Default to USDT
  }

  //Temporary Storage for Withdrawal Flow ---
  static const String tempWithdrawAddr = 'temp_withdraw_addr';
  static const String tempWithdrawAmount = 'temp_withdraw_amount';
  static const String tempWithdrawPwd = 'temp_withdraw_pwd';

  static Future<void> saveTempWithdrawData(String addr, String amount, String pwd) async {
    if (_prefs == null) await init();
    await _prefs!.setString(tempWithdrawAddr, addr);
    await _prefs!.setString(tempWithdrawAmount, amount);
    await _prefs!.setString(tempWithdrawPwd, pwd);
  }

  static Future<Map<String, String?>> getTempWithdrawData() async {
    if (_prefs == null) await init();
    return {
      'addr': _prefs!.getString(tempWithdrawAddr),
      'amount': _prefs!.getString(tempWithdrawAmount),
      'pwd': _prefs!.getString(tempWithdrawPwd),
    };
  }

  static Future<void> clearTempWithdrawData() async {
    if (_prefs == null) await init();
    await _prefs!.remove(tempWithdrawAddr);
    await _prefs!.remove(tempWithdrawAmount);
    await _prefs!.remove(tempWithdrawPwd);
  }
  static const String hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const String tokenTimestampKey = 'token_timestamp';

  // Save Onboarding Complete
  static Future<bool> saveOnboardingComplete() async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(hasCompletedOnboardingKey, true);
  }

  // Get Onboarding Status
  static Future<bool> hasCompletedOnboarding() async {
    if (_prefs == null) await init();
    return _prefs!.getBool(hasCompletedOnboardingKey) ?? false;
  }

  // Save Token with Timestamp
  static Future<bool> saveToken(String token) async {
    if (_prefs == null) await init();
    print("SAVING TOKEN : $token ");
    await _prefs!.setInt(tokenTimestampKey, DateTime.now().millisecondsSinceEpoch);
    return await _prefs!.setString(userToken, token);
  }

  // Check if Token is Valid (7 days)
  static Future<bool> isTokenValid() async {
    if (_prefs == null) await init();
    final timestamp = _prefs!.getInt(tokenTimestampKey);
    if (timestamp == null) return false;

    final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final daysDifference = DateTime.now().difference(savedTime).inDays;
    
    // Check if token is older than 7 days
    if (daysDifference >= 7) {
      await removeToken(); 
      return false;
    }
    return true;
  }

  static const String isRememberMeKey = 'is_remember_me';

  // Save Remember Me
  static Future<bool> saveRememberMe(bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(isRememberMeKey, value);
  }

  // Get Remember Me
  static Future<bool> getRememberMe() async {
    if (_prefs == null) await init();
    return _prefs!.getBool(isRememberMeKey) ?? false;
  }

  /// Set whether to pop up a pop-up window indicating successful authentication.
  static Future<bool> setMerchantSucTip(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = '${merchantSucTip}_$userId';
    return prefs.setBool(key, true);
  }

  /// Get whether a pop-up window indicating successful authentication has popped up
  static Future<bool> getMerchantSucTip(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = '${merchantSucTip}_$userId';
    final bool? value = prefs.getBool(key);
    return value ?? false;
  }
}
