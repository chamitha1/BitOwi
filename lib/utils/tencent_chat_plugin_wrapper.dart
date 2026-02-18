// Exports the real plugin for Mobile (default)
// Exports the stub for Web (dart.library.html)

export 'package:tencent_cloud_chat_customer_service_plugin/tencent_cloud_chat_customer_service_plugin.dart'
    if (dart.library.html) 'tencent_chat_plugin_stub.dart';
