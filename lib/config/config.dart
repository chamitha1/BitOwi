class AppConfig {
  static const String appName = 'BitOwi';

  static const bool isBuildApk = bool.fromEnvironment("dart.vm.product");

  // static const String apiUrl = 'http://api.dev.bitdowallet.com/api'; //dev
  // static const String webApiUrl = 'http://api.dev.bitdowallet.com/api';

  static const String apiUrl = 'http://m-test.bitowi.com/api'; //test
  static const String webApiUrl = 'http://m-test.bitowi.com/api';

  // static const String apiUrl = 'https://m.bitowi.com/api'; //live
  // static const String webApiUrl = 'https://m.bitowi.com/api';
}
