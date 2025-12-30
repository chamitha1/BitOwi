class AppConfig {
  static const String appName = 'BitOwi';

  static const bool isBuildApk = bool.fromEnvironment("dart.vm.product");

  // static const String apiUrl = 'http://api.dev.bitdowallet.com/api';
  // static const String webApiUrl = 'http://api.dev.bitdowallet.com/api';

  static const String apiUrl = 'http://m-test.bitowi.com/api';
  static const String webApiUrl = 'http://m-test.bitowi.com/api';
}
