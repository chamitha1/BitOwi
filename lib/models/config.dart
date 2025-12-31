/// System parameter return value
class Config {
  late Map<String, String> data;

  Config();

  factory Config.fromJson(Map<String, dynamic> json) {
    Config config = Config();
    config.data = {};
    for (var ele in json.entries) {
      config.data[ele.key] = ele.value;
    }
    return config;
  }
  Map<String, dynamic> toJson() => data;
}
